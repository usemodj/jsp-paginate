<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page language="java"%>
<%@ page import="java.sql.*"%>
<%!public int nullIntconvert(String str) {
		int num = 0;
		if (str == null) {
			str = "0";
		} else if ((str.trim()).equals("null")) {
			str = "0";
		} else if (str.equals("")) {
			str = "0";
		}
		try {
			num = Integer.parseInt(str);
		} catch (Exception e) {
		}
		return num;
	}%>
<%
	Connection conn = null;
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	conn = DriverManager.getConnection(
			"jdbc:mysql://localhost:3306/jpetstore", "root", "");
	ResultSet rs1 = null;
	ResultSet rs2 = null;
	PreparedStatement ps1 = null;
	PreparedStatement ps2 = null;

	int showRows =2;
	int totalRecords = 10;
	int totalRows = nullIntconvert(request.getParameter("totalRows"));
	int totalPages = nullIntconvert(request.getParameter("totalPages"));
	int iPageNo = nullIntconvert(request.getParameter("iPageNo"));
	int cPageNo = nullIntconvert(request.getParameter("cPageNo"));

	int startResult = 0;
	int endResult = 0;
	if (iPageNo == 0) {
		iPageNo = 0;
	} else {
		iPageNo = Math.abs((iPageNo - 1) * showRows);
	}
	String query1 = "SELECT SQL_CALC_FOUND_ROWS * FROM jpetstore.item  LIMIT "
			+ iPageNo + "," + showRows + "";
	ps1 = conn.prepareStatement(query1);
	rs1 = ps1.executeQuery();

	String query2 = "SELECT FOUND_ROWS() as cnt";
	ps2 = conn.prepareStatement(query2);
	rs2 = ps2.executeQuery();
	if (rs2.next()) {
		totalRows = rs2.getInt("cnt");
	}
%>
<html>
<h3>Pagination of JSP page</h3>
<body>
	<form>
		<input type="hidden" name="iPageNo" value="<%=iPageNo%>"> <input
			type="hidden" name="cPageNo" value="<%=cPageNo%>"> <input
			type="hidden" name="showRows" value="<%=showRows%>">
		<table width="100%" cellpadding="0" cellspacing="0"  border="1">
			<tr>
				<td>ItemID</td>
				<td>ProductID</td>
				<td>listPrice</td>
				<td>unitCost</td>
			</tr>
			<%
				while (rs1.next()) {
			%>
			<tr>
				<td><%=rs1.getString("itemid")%></td>
				<td><%=rs1.getString("productId")%></td>
				<td><%=rs1.getDouble("listprice")%></td>
				<td><%=rs1.getDouble("unitcost")%></td>
			</tr>
			<%
				}
			%>

			<%
				try {
					if (totalRows < (iPageNo + showRows)) {
						endResult = totalRows;
					} else {
						endResult = (iPageNo + showRows);
					}
					startResult = (iPageNo + 1);
					totalPages = ((int) (Math.ceil((double) totalRows / showRows)));
				} catch (Exception e) {
					e.printStackTrace();
				}
			%>
			<tr>
				<td colspan="3">
					<div>
						<%
							int i = 0;
							int cPage = 0;
							if (totalRows != 0) {
								cPage = ((int) (Math.ceil((double) endResult
										/ (totalRecords * showRows))));

								int prePageNo = (cPage * totalRecords)
										- ((totalRecords - 1) + totalRecords);
								if ((cPage * totalRecords) - (totalRecords) > 0) {
						%>
						<a
							href="pagination.jsp?iPageNo=<%=prePageNo%>&cPageNo=<%=prePageNo%>">
							&lt;&lt; Previous</a>
						<%
							}
								for (i = ((cPage * totalRecords) - (totalRecords - 1)); i <= (cPage * totalRecords); i++) {
									if (i == ((iPageNo / showRows) + 1)) {
						%>
						<a href="pagination.jsp?iPageNo=<%=i%>"
							style="cursor: pointer; color: red"><b><%=i%></b> </a>
						<%
							} else if (i <= totalPages) {
						%>
						<a href="pagination.jsp?iPageNo=<%=i%>"><%=i%></a>
						<%
							}
								}
								if (totalPages > totalRecords && i < totalPages) {
						%>
						<a href="pagination.jsp?iPageNo=<%=i%>&cPageNo=<%=i%>"> &gt;&gt;
							Next</a>
						<%
							}
							}
						%>
						<b>Rows <%=startResult%> - <%=endResult%> Total Rows <%=totalRows%>
						</b>
					</div>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>
<%
	try {
		if (ps1 != null) {
			ps1.close();
		}
		if (rs1 != null) {
			rs1.close();
		}

		if (ps2 != null) {
			ps2.close();
		}
		if (rs2 != null) {
			rs2.close();
		}

		if (conn != null) {
			conn.close();
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
%>