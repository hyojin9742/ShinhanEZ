<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../inc/header.jsp" %>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">DashBoard</h1>
	</div>
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">
					DashBoard
					<button id='regBtn' type="button" class="btn btn-xs pull-right btn-primary">
						Register New Board
					</button>
				</div>
				<!-- /.panel-heading -->
				<div class="panel-body">
					<table width="100%" class="table table-striped table-bordered table-hover">
						<thead>
							<tr>
								<th>번호</th>
								<th>제목</th>
								<th>작성자</th>
								<th>작성일</th>
								<th>수정일</th>
							</tr>
						</thead>
						<tbody>
						
						</tbody>
					</table>

					<div class="row">
						<div class="col-lg-12">
							
						</div>
					</div>
					
					<!-- Modal 추가 작업 -->
		            <div class="modal fade" id="myModal" tabindex="-1" role="dialog"
		               aria-labelledby="myModalLabel" aria-hidden="true">
		               <div class="modal-dialog">
		                  <div class="modal-content">
		                     <div class="modal-header">
		                        <button type="button" class="close" data-dismiss="modal"
		                           aria-hidden="true">&times;</button>
		                        <h4 class="modal-title" id="myModalLabel">Modal title</h4>
		                     </div>
		                     <div class="modal-body">처리가 완료되었습니다.</div>
		                     <div class="modal-footer">
		                        <button type="button" class="btn btn-default"
		                           data-dismiss="modal">Close</button>
		                        <button type="button" class="btn btn-primary"
		                           data-dismiss="modal">Save changes</button>
		                     </div>
		                  </div>
		               </div>
		            </div>
					<!-- /Modal 추가 작업 -->
				</div>
			</div>
		</div>
	</div>
</div>

<%@ include file="../inc/footer.jsp" %>
