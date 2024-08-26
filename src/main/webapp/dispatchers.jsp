<%@page import="com.klef.ep.models.Admin"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="java.util.List"%>
<%@page import="javax.ejb.EJB"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Courier Service Management - Admin Page</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"/>
    <style>
        body {
            font-family: 'DM Sans', sans-serif;
            display: flex;
            margin: 0;
            background-color: #f8f9fa;
            color: #333;
        }
        .sidebar {
            width: 250px;
            background-color: #343a40;
            color: #fff;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            height: 100vh;
            position: fixed;
        }
        .sidebar .logo {
            text-align: center;
            padding: 20px;
            font-size: 24px;
            background-color: #212529;
            border-bottom: 1px solid #495057;
        }
        .sidebar ul {
            list-style-type: none;
            padding: 0;
            margin: 0;
        }
        .sidebar li {
            padding: 15px 20px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .sidebar li:hover {
            background-color: #495057;
        }
        .sidebar li i {
            margin-right: 10px;
        }
        .dropdown {
            display: none;
            list-style-type: none;
            padding-left: 20px;
            background-color: #495057;
        }
        .dropdown li {
            padding: 10px 20px;
            cursor: pointer;
        }
        .dropdown-toggle:hover .dropdown,
        .dropdown-toggle:focus .dropdown {
            display: block;
        }
        .dropdown li:hover {
            background-color: #6c757d;
        }
        .logout {
            padding: 20px;
            text-align: center;
            cursor: pointer;
            background-color: #212529;
            border-top: 1px solid #495057;
        }
        .logout:hover {
            background-color: #495057;
        }
        .main-content {
            margin-left: 250px;
            padding: 20px;
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        .header {
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: #ffffff;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        .new-dispatcher-button {
            padding: 10px 20px;
            background-color: #28a745;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .new-dispatcher-button:hover {
            background-color: #218838;
        }
        .dashboard {
            padding: 20px;
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        .dashboard-metrics {
            display: flex;
            justify-content: space-around;
            margin-bottom: 20px;
        }
        .dashboard-metrics div {
            background-color: #eee;
            padding: 20px;
            border-radius: 10px;
            flex: 1;
            margin: 0 10px;
            text-align: center;
            transition: background-color 0.3s;
        }
        .dashboard-metrics div:hover {
            background-color: #ddd;
        }
        .dispatchers-list {
            background-color: #ffffff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .dispatchers-table {
            width: 100%;
            border-collapse: collapse;
        }
        .dispatchers-table th, .dispatchers-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        .dispatchers-table th {
            background-color: #f2f2f2;
        }
        .edit-button {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .edit-button:hover {
            background-color: #0056b3;
        }
        .right-bar {
            width: 250px;
            background-color: #f4f4f4;
            padding: 20px;
            display: flex;
            flex-direction: column;
            position: fixed;
            right: 0;
            height: 100vh;
        }
        .admin-profile {
            display: flex;
            align-items: center;
        }
        .admin-profile img {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            margin-right: 10px;
        }
        .recent-updates {
            margin-top: 20px;
            flex: 1;
            overflow-y: auto;
        }
        .recent-updates ul {
            list-style-type: none;
            padding: 0;
            margin: 0;
        }
        .recent-updates li {
            padding: 10px;
            background-color: #ffffff;
            border-radius: 5px;
            margin-bottom: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            transition: background-color 0.3s;
        }
        .recent-updates li:hover {
            background-color: #f8f9fa;
        }
        .recent-updates h2 {
            margin-bottom: 10px;
        }
        .date-picker input[type="date"] {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.5);
            padding-top: 60px;
        }
        .modal-content {
            background-color: #fff;
            margin: 5% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
            max-width: 600px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .modal-content form {
            display: flex;
            flex-direction: column;
        }
        .modal-content form input,
        .modal-content form button {
            margin-bottom: 10px;
        }
        .modal-content form button {
            padding: 10px;
            background-color: #28a745;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .modal-content form button:hover {
            background-color: #218838;
        }
        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }
        .close:hover,
        .close:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="sidebar">
        <div>
            <div class="logo">ShipIt <i class="fas fa-shipping-fast"></i></div>
            <ul>
                <li><i class="fas fa-tachometer-alt"></i> Dashboard</li>
                <li><i class="fas fa-user-shield"></i> Admins</li>
                <li class="dropdown-toggle"><i class="fas fa-sitemap"></i> Branch Control
                    <ul class="dropdown">
                        <li>Manage Control</li>
                        <li>Branch Manager</li>
                        <li>Branch Income</li>
                    </ul>
                </li>
                <li><i class="fas fa-box"></i> Manage Courier</li>
                <li class="dropdown-toggle"><i class="fas fa-users"></i> Staff List
                    <ul class="dropdown">
                        <li><a href="dispatcher.xhtml">Dispatcher</a></li>
                    </ul>
                </li>
                <li><i class="fas fa-address-book"></i> Customer List</li>
                <li class="dropdown-toggle"><i class="fas fa-life-ring"></i> Support Ticket
                    <ul class="dropdown">
                        <li>Pending</li>
                        <li>Answered</li>
                        <li>Closed</li>
                        <li>All</li>
                    </ul>
                </li>
                <li class="dropdown-toggle"><i class="fas fa-chart-bar"></i> Report
                    <ul class="dropdown">
                        <li>Login History</li>
                        <li>Notification History</li>
                    </ul>
                </li>
            </ul>
        </div>
        <div class="logout"><i class="fas fa-sign-out-alt"></i> Logout</div>
    </div>

    <div class="main-content">
        <div class="header">
            <div class="date-picker">
                <input type="date" id="dashboard-date" name="dashboard-date"/>
            </div>
            <button class="new-dispatcher-button" id="new-dispatcher-button">New Dispatcher</button>
        </div>
        <div class="dashboard">
            <div class="dashboard-metrics">
                <div>Total Deliveries: <span id="total-deliveries">0</span></div>
                <div>Total Income: <span id="total-income">$0</span></div>
                <div>Total Employees: <span id="total-employees">0</span></div>
            </div>
            <div class="dispatchers-list">
                <h2>Dispatchers List</h2>
                <table class="dispatchers-table">
                    <thead>
                        <tr>
                            <th>Username</th>
                            <th>Password</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="dispatchers-table-body">
                        <!-- Dispatchers will be populated here -->
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- The Modal -->
    <div id="dispatcherModal" class="modal">
        <div class="modal-content">
            <span class="close" id="closeModal">&times;</span>
            <h2>New Dispatcher</h2>
            <form id="dispatcherForm">
                <label for="dispatcherFullName">Username:</label><br>
                <input type="text" id="dispatcherUsername" name="dispatcherUsername" required><br>
                <label for="dispatcherContact">Contact:</label><br>
                <input type="text" id="dispatcherContact" name="dispatcherContact" required><br>
                <label for="dispatcherEmail">Email:</label><br>
                <input type="email" id="dispatcherEmail" name="dispatcherEmail" required><br>
                <label for="dispatcherAddress">Address:</label><br>
                <input type="text" id="dispatcherAddress" name="dispatcherAddress" required><br>
                <label for="dispatcherCity">City:</label><br>
                <input type="text" id="dispatcherCity" name="dispatcherCity" required><br>
                <label for="dispatcherPinCode">Pin Code:</label><br>
                <input type="text" id="dispatcherPinCode" name="dispatcherPinCode" required><br>
                <label for="dispatcherPassword">Password:</label><br>
                <input type="password" id="dispatcherPassword" name="dispatcherPassword" required><br>
                <label for="dispatcherRetypePassword">Retype Password:</label><br>
                <input type="password" id="dispatcherRetypePassword" name="dispatcherRetypePassword" required><br>
                <button type="submit">Add Dispatcher</button>
            </form>
        </div>
    </div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Dropdown toggle functionality
        const dropdownToggles = document.querySelectorAll('.dropdown-toggle');
        dropdownToggles.forEach(toggle => {
            toggle.addEventListener('mouseenter', () => {
                const dropdown = toggle.querySelector('.dropdown');
                dropdown.style.display = 'block';
            });
            toggle.addEventListener('mouseleave', () => {
                const dropdown = toggle.querySelector('.dropdown');
                dropdown.style.display = 'none';
            });
        });

        // Modal control
        const modal = document.getElementById('dispatcherModal');
        const newDispatcherButton = document.getElementById('new-dispatcher-button');
        const closeModalButton = document.getElementById('closeModal');
        let editMode = false;
        let editRow = null;

        newDispatcherButton.addEventListener('click', () => {
            modal.style.display = 'block';
            document.getElementById('dispatcherForm').reset();
            editMode = false;
            editRow = null;
        });

        closeModalButton.addEventListener('click', () => {
            modal.style.display = 'none';
        });

        window.addEventListener('click', (event) => {
            if (event.target == modal) {
                modal.style.display = 'none';
            }
        });

        // Handle form submission
        const dispatcherForm = document.getElementById('dispatcherForm');
        dispatcherForm.addEventListener('submit', (event) => {
            event.preventDefault();

            const fullName = document.getElementById('dispatcherFullName').value;
            const contact = document.getElementById('dispatcherContact').value;
            const email = document.getElementById('dispatcherEmail').value;
            const address = document.getElementById('dispatcherAddress').value;
            const city = document.getElementById('dispatcherCity').value;
            const pinCode = document.getElementById('dispatcherPinCode').value;
            const username = document.getElementById('dispatcherUsername').value;
            const password = document.getElementById('dispatcherPassword').value;

            const dispatcherTableBody = document.getElementById('dispatchers-table-body');

            if (editMode && editRow) {
                editRow.innerHTML = `<td>${username}</td>
                                     <td>${password}</td>
                                     <td><button class="edit-button">Edit</button></td>`;
            } else {
                const row = document.createElement('tr');
                row.innerHTML = `<td>${username}</td>
                                  <td>${password}</td>
                                  <td><button class="edit-button">Edit</button></td>`;
                dispatcherTableBody.appendChild(row);
            }

            // Update total employees count
            const totalEmployeesElement = document.getElementById('total-employees');
            const totalEmployees = parseInt(totalEmployeesElement.innerText);
            totalEmployeesElement.innerText = editMode ? totalEmployees : totalEmployees + 1;

            modal.style.display = 'none';
            dispatcherForm.reset();
            editMode = false;
            editRow = null;
        });

        // Edit button functionality
        document.getElementById('dispatchers-table-body').addEventListener('click', (event) => {
            if (event.target.classList.contains('edit-button')) {
                const row = event.target.closest('tr');
                const cells = row.getElementsByTagName('td');

                document.getElementById('dispatcherFullName').value = cells[0].innerText; // Adjust based on actual content
                document.getElementById('dispatcherUsername').value = cells[0].innerText;
                document.getElementById('dispatcherPassword').value = cells[1].innerText;
                // Populate other fields as needed
                // Assuming you have values stored somewhere else or need to adjust accordingly.

                modal.style.display = 'block';
                editMode = true;
                editRow = row;
            }
        });
    });
</script>


</body>
</html>
