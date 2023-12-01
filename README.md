# Task Manager Application Description and Dataflow Diagram
## Application Description
The Task Manager Application is a Flask-based web application that integrates user management, user authentication, and task management functionalities. The application consists of three main components: User Management, API, and UI. These components are deployed as separate services within a Dockerized environment and orchestrated using Kubernetes. PostgreSQL is used as the backend database to store user and task data.

## Components:
### User Management Service:
* Responsible for user registration, login, and authentication. 
* Stores user data (username, email, password) in the PostgreSQL database.
* Exposes endpoints for user registration (/register), user login (/login), and retrieving user information.

### API Service:
* Manages tasks, including adding and deleting tasks.
* Interacts with the PostgreSQL database to perform CRUD operations on tasks.
* Exposes endpoints for adding tasks (/tasks/add), deleting tasks (/tasks/delete/<task_id>), and retrieving all tasks (/tasks).

### I Service:
* Provides a web interface for users to interact with the application.
* Renders HTML templates for user authentication, task management, and the main index page.
* Communicates with the User Management and API services to perform user-related and task-related operations.

### PostgreSQL Database:
* Stores user and task data in separate tables.

## Dataflow Diagram

+---------------------+        +-------------------------+        +-----------------------+
|                     |        |                         |        |                       |
|     UI Service      +------->+  User Management API    +-------->  PostgreSQL Database  |
|                     |        |                         |        |                       |
+---------------------+        +-------------------------+        +-----------------------+
       ^                                                                      |
       |                                                                      |
       |                                                                      |
       |             +--------------------+        +------------------+       |
       +------------>|                    |        |                  |       |
                     | Task API Service   +------->+  PostgreSQL      |       |
       +------------>|                    |        |   Database       |       |
       |             +--------------------+        +------------------+       |
       |                                                                      |
       |                                                                      |
       +----------------------------------------------------------------------+


1. The UI Service is the entry point for users and loads the main index page.
2. If a user is not logged in, the UI Service redirects to the login page.
3. If the user is not registered, the UI Service reroutes to the registration page.
4. Upon registration, the UI Service sends user registration information to the User Management API.
5. The User Management API stores user data in the PostgreSQL database and responds with an OK status.
6. Users can then log in using their credentials.
7. Once authenticated, the UI Service allows users to interact with the application, including adding and deleting tasks.
8. Task-related operations trigger requests to the API Service.
9. The API Service performs CRUD operations on tasks in the PostgreSQL database.
10. The UI Service reflects changes to tasks based on the responses from the API Service.