<%@page import="com.klef.ep.models.Parcel"%>
<%@page import="com.klef.ep.beans.ParcelBean"%>
<%@page import="javax.naming.Context"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.NamingException"%>
<%@page import="javax.servlet.http.HttpSession"%>
<%@page import="com.klef.ep.models.Client"%>
<%@page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<%
Client cli = (Client) session.getAttribute("client");
if(cli == null) {
  response.sendRedirect("sessionexpiry.html");
  return;
}

String searchType = request.getParameter("searchType");
String searchValue = request.getParameter("trackstatus");

ParcelBean parcelBean = null;
try {
    Context ctx = new InitialContext();
    parcelBean = (ParcelBean) ctx.lookup("java:global/EPProject/ParcelBean!com.klef.ep.beans.ParcelBean");
} catch (NamingException e) {
    out.println("Error looking up ParcelBean: " + e.getMessage());
    return;
}

Parcel parcel = parcelBean != null ? parcelBean.viewParcel(searchType, searchValue) : null;
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Parcel Status</title>
    <link rel="stylesheet" type="text/css" href="style.css">
    <style>
        /* Responsive HTML Table With Pure CSS - Web Design/UI Design */

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: sans-serif;
        }
        @media print {
            .table, .table__body {
                overflow: visible;
                height: auto !important;
                width: auto !important;
            }
        }
        body {
            min-height: 100vh;
            background: url(images/html_table.jpg) center / cover;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        main.table {
            width: 82vw;
            height: 90vh;
            background-color: #fff5;
            backdrop-filter: blur(7px);
            box-shadow: 0 .4rem .8rem #0005;
            border-radius: .8rem;
            overflow: hidden;
        }
        .table__header {
            width: 100%;
            height: 10%;
            background-color: #fff4;
            padding: .8rem 1rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .table__header .input-group {
            width: 35%;
            height: 100%;
            background-color: #fff5;
            padding: 0 .8rem;
            border-radius: 2rem;
            display: flex;
            justify-content: center;
            align-items: center;
            transition: .2s;
        }
        .table__header .input-group:hover {
            width: 45%;
            background-color: #fff8;
            box-shadow: 0 .1rem .4rem #0002;
        }
        .table__header .input-group img {
            width: 1.2rem;
            height: 1.2rem;
        }
        .table__header .input-group input {
            width: 100%;
            padding: 0 .5rem 0 .3rem;
            background-color: transparent;
            border: none;
            outline: none;
        }
        .table__body {
            width: 95%;
            max-height: calc(89% - 1.6rem);
            background-color: #fffb;
            margin: .8rem auto;
            border-radius: .6rem;
            overflow: auto;
            overflow: overlay;
        }
        .table__body::-webkit-scrollbar {
            width: 0.5rem;
            height: 0.5rem;
        }
        .table__body::-webkit-scrollbar-thumb {
            border-radius: .5rem;
            background-color: #0004;
            visibility: hidden;
        }
        .table__body:hover::-webkit-scrollbar-thumb {
            visibility: visible;
        }
        table {
            width: 100%;
        }
        td img {
            width: 36px;
            height: 36px;
            margin-right: .5rem;
            border-radius: 50%;
            vertical-align: middle;
        }
        table, th, td {
            border-collapse: collapse;
            padding: 1rem;
            text-align: left;
        }
        thead th {
            position: sticky;
            top: 0;
            left: 0;
            background-color: #d5d1defe;
            cursor: pointer;
            text-transform: capitalize;
        }
        tbody tr:nth-child(even) {
            background-color: #0000000b;
        }
        tbody tr {
            --delay: .1s;
            transition: .5s ease-in-out var(--delay), background-color 0s;
        }
        tbody tr.hide {
            opacity: 0;
            transform: translateX(100%);
        }
        tbody tr:hover {
            background-color: #fff6 !important;
        }
        tbody tr td,
        tbody tr td p,
        tbody tr td img {
            transition: .2s ease-in-out;
        }
        tbody tr.hide td,
        tbody tr.hide td p {
            padding: 0;
            font: 0 / 0 sans-serif;
            transition: .2s ease-in-out .5s;
        }
        tbody tr.hide td img {
            width: 0;
            height: 0;
            transition: .2s ease-in-out .5s;
        }
        .status {
            padding: .4rem 0;
            border-radius: 2rem;
            text-align: center;
        }
        .status.godown {
            background-color: red;
            color: #fff;
        }
        .status.dispatching {
            background-color: yellow;
            color: #000;
        }
        .status.delivered {
            background-color: green;
            color: #fff;
        }
        @media (max-width: 1000px) {
            td:not(:first-of-type) {
                min-width: 12.1rem;
            }
        }
        thead th span.icon-arrow {
            display: inline-block;
            width: 1.3rem;
            height: 1.3rem;
            border-radius: 50%;
            border: 1.4px solid transparent;
            text-align: center;
            font-size: 1rem;
            margin-left: .5rem;
            transition: .2s ease-in-out;
        }
        thead th:hover span.icon-arrow {
            border: 1.4px solid #6c00bd;
        }
        thead th:hover {
            color: #6c00bd;
        }
        thead th.active span.icon-arrow {
            background-color: #6c00bd;
            color: #fff;
        }
        thead th.asc span.icon-arrow {
            transform: rotate(180deg);
        }
        thead th.active, tbody td.active {
            color: #6c00bd;
        }
    </style>
</head>

<body>
    <section class="table__body">
        <table>
            <thead>
                <tr>
                    <th>Parcel Name</th>
                    <th>Sender</th>
                    <th>Receiver</th>
                    <th>Shipping Type</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                if (parcel != null) {
                %>
                    <tr>
                        <td><%= parcel.getPname() %><br>
                        	type = <%= parcel.getPtype() %>
                        </td>
                        <td><%= parcel.getSname() %><br>
                        		<%= parcel.getScontact() %><br>
                        		<%= parcel.getScity() %>
                        </td>
                        <td><%= parcel.getRname() %><br>
                        	<%= parcel.getRcontact() %><br>
                        	<%= parcel.getRcity() %><br>
                        </td>
                        <td>
                        <%! String shiptype = ""; %>
                        <% if(parcel.getShipping_type().contains("SDC")){
                        		shiptype="Standard Delivery Service";
                        	}else if(parcel.getShipping_type().contains("LCS")){
                        		shiptype="Local Courier Services";
                        	}else if(parcel.getShipping_type().contains("GCS")){
                        		shiptype="Global Courier Services";
                        	}else if(parcel.getShipping_type().contains("SAMEDC")){
                        		shiptype="Same-Day Couriers";
                        	}else if(parcel.getShipping_type().contains("OS")){
                        		shiptype="Overnight Shipping";
                        	}else if(parcel.getShipping_type().contains("ROD")){
                        		shiptype="Rush and On-Demand Deliveries";
                        	}else if(parcel.getShipping_type().contains("SD")){
                        		shiptype="Scheduled Deliveries";
                        	}
                        %>
                        <%=shiptype %>
                        </td>
                        <td>
                            <p class="status <%= parcel.getStatus().toLowerCase() %>"><%= parcel.getStatus() %></p>
                        </td>
                    </tr>
                <%
                } else {
                %>
                    <tr>
                        <td colspan="5">No Parcel Found</td>
                    </tr>
                <%
                }
                %>
            </tbody>
        </table>
    </section>

</body>

</html>
