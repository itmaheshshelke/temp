<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<div class="col-lg-12 grid-margin stretch-card">
              <div class="card">
                <div class="card-body">
                  <h4 class="card-title">User List</h4>
                  <form method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/excel-api/upload-excel">
                  <div class="form-group">
                      <label>File upload</label>
                     
                      <div class="input-group col-xs-12">
                        <input type="file" class="form-control file-upload-info" name="file" placeholder="Upload Image" required="required">
                        <span class="input-group-append">
                          <button class="file-upload-browse btn btn-gradient-primary" type="submit">Upload</button>
                        </span>
                      </div>
                    </div>
                  
                  </form>
                  <c:if test="${ errorMessage !=null}">
                  <span class="row col-md-12 alert alert-danger">${errorMessage }</span>
                  </c:if>
                  <c:if test="${ successMessage !=null}">
                  <span class="row col-md-12 alert alert-success">${successMessage }</span>
                  </c:if>
                  <input type = "hidden" id = "min">
                  <input type = "hidden" id = "max">
                  <form method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/excel-api/delete-selected-user">
                  <table class="table table-bordered" id="example">
					<thead>
						<tr>
							<th>Sr. No</th>
							<th>First name</th>
							<th>Last Name</th>
							<th>Email Id</th>
							<th>Contact No</th>
							<th>Gender</th>
							<th>Password</th>
							<th>
							<div class="form-check">
								<label class="form-check-label text-muted"> <input
									type="checkbox" class="form-check-input sendallemail" name="sendEmailToAll">
									select All
								</label>
							</div>
						</th>
							<th>Action</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${excelList}" var="excel" varStatus="loop">
							<tr>
								<td class="col-sm-2" style="width: 100px;">${loop.index+1}</td>
								<td class="col-sm-2" style="width: 100px;">${excel.firstName}</td>
								<td class="col-sm-2" style="width: 200px;">${excel.lastName}</td>
								<td class="col-sm-2" style="width: 200px;">${excel.emailId}</td>
								<td class="col-sm-2" style="width: 200px;">${excel.contactNo}</td>
								<td class="col-sm-2" style="width: 200px;">${excel.gender}</td>
								<td class="col-sm-2" style="width: 200px;">${excel.password}</td>
								<td class="col-sm-2" style="width: 100px;">
													<div class="form-check form-group m-tt-5" style="margin-top:-10px">
													<label class="form-check-label text-muted"> <input
														type="checkbox" class="form-check-input sendemail" name="deleteUser" value="${excel.employeeId}">
				
													</label>
													</div></td>
								<td class="col-sm-2" style="width: 80px;">
								<a href="${pageContext.request.contextPath}/excel-api/edit-user-record?employeeId=${excel.employeeId}"
									title="Edit" class="colorIcon"><i class="mdi mdi-border-color"></i></a> | 
									<a href="${pageContext.request.contextPath}/excel-api/delete-user-data/${excel.employeeId}" title="Delete" class="colorIcon"><i class="mdi mdi-delete-forever"></i></a>
							</td>
							</tr>
						</c:forEach>
					</tbody>
                  </table>
                   <hr style="size: 10px">
                  <div class="form-group">
                      <div class="input-group col-xs-12">
                      	<span class="col-md-4"></span>
                      		<span class="col-md-4"></span>
                          <button class="pull-right col-md-4 file-upload-browse btn btn-gradient-primary" type="submit">Delete selected</button>
                       
                      </div>
                    </div>
                  </form>
                </div>
              </div>
            </div>

</html>
 <script src = "https://code.jquery.com/jquery-3.3.1.js"></script>
<script>
	$(document).ready(function() {
   /*  $('#example').DataTable( {
        //"pagingType": "full_numbers"
    } ); */
    var classname;
    $('.sendallemail').click(function(){
    	
    		classname = "sendemail";
    	
    	
    	for(var i=0; i<$('.'+classname).length; i++){
    		if($(this).prop('checked')){
    			$($('.'+classname)[i]).prop('checked', true)
    		}else{
    			$($('.'+classname)[i]).prop('checked', false)
    		}
    	}
    })
} );
	
	setTimeout(function() {
		$('#successMessage').fadeOut('fast');
	}, 5000);
	
	setTimeout(function() {
		$('#errorMessage').fadeOut('fast');
	}, 5000);
 </script>
 
 
 
 
 
 
 
 
 
 @RequestMapping(value = "/delete-selected-user", method = RequestMethod.POST)
	public ModelAndView deleteSelectedUsers(HttpServletRequest request,
			HttpServletResponse response, RedirectAttributes attribute) {
		ModelAndView model=new ModelAndView("show-excel");
		String userIds[]=request.getParameterValues("deleteUser");
		try {
			if(userIds!=null) {
				for (String userId : userIds) {
					Excel excel = excelRepository.getUserDataById(Integer.parseInt(userId));
					excel.setUpdatedBy(1);
					excel.setUpdatedOn(new Date());
					excel.setDelFlag('Y');
					excelRepository.save(excel);
					excelRepository.flush();
				}
			
			}
		} catch (Exception e) {
		}
		model.addObject("successMessage", "Record deleted successfully");
		List<Excel> excelList = excelRepository.getAll();
		model.addObject("excelList", excelList);
		return model;
	}