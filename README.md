# Task Manager Application

## Application Description

The Task Manager Application is a Flask-based web application that integrates user management, user authentication, and task management functionalities. The application consists of three main components: User Management, API, and UI. These components are deployed as separate services within a Dockerized environment and orchestrated using Kubernetes. PostgreSQL is used as the backend database to store user and task data.

## Components:

### User Management Service:

- Responsible for user registration, login, and authentication.
- Stores user data (username, email, password) in the PostgreSQL database.
- Exposes endpoints for user registration (/register), user login (/login), and retrieving user information.

### API Service:

- Manages tasks, including adding and deleting tasks.
- Interacts with the PostgreSQL database to perform CRUD operations on tasks.
- Exposes endpoints for adding tasks (/tasks/add), deleting tasks (/tasks/delete/<task_id>), and retrieving all tasks (/tasks).

### UI Service:

- Provides a web interface for users to interact with the application.
- Renders HTML templates for user authentication, task management, and the main index page.
- Communicates with the User Management and API services to perform user-related and task-related operations.

### PostgreSQL Database:

- Stores user and task data in separate tables.

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

## Discussion of Benefits and Challenges in the Architecture Design

### Benefits:

- **Modularity and Microservices:**
  The use of microservices architecture with separate services for UI, User Management API, Task API, and Database provides modularity and ease of maintenance. Each service can be developed, deployed, and scaled independently, enabling agility in development.

- **Scalability:**
  The microservices approach allows for horizontal scalability, where individual components can be scaled based on demand. This enables better resource utilization and the ability to handle varying workloads efficiently.

- **Flexibility with Kubernetes:**
  Deployment on Kubernetes provides easy orchestration and management of containerized applications. Kubernetes allows for automated scaling, rolling updates, and high availability, enhancing the overall system reliability.

- **Separation of Concerns:**
  Each service is responsible for a specific set of functionalities, promoting the separation of concerns. User Management, Task Management, and Database functionalities are isolated, making it easier to understand, develop, and maintain each service.

### Challenges:

- **Security Concerns:**
  The communication between microservices and the database might introduce security vulnerabilities if not properly secured. Sensitive information, such as database credentials, is stored in ConfigMaps, which poses a security risk if not adequately protected. In short, there are no security measures implemented at all other than the basic functionalities provided by the framework.

- **ConfigMap Security:**
  Storing sensitive information like database credentials in ConfigMaps is a potential security risk. ConfigMaps are accessible to anyone with the appropriate Kubernetes permissions, and this can lead to unauthorized access.

### Security Considerations and Mitigations:

- **Secure Communication:**
  - Implement HTTPS for communication between services to encrypt data in transit.
  - Use authentication tokens and validate user identity during API requests to prevent unauthorized access.
  - Utilize Kubernetes Secrets instead of ConfigMaps for sensitive information, as Secrets are more secure and can be encrypted at rest.

- **Database Security:**
  - Ensure that the database is properly configured with access controls and restricted permissions.
  - Use strong and unique passwords for database access.
  - Regularly update and patch the database system to address any security vulnerabilities.

- **Kubernetes RBAC:**
  - Implement Role-Based Access Control (RBAC) in Kubernetes to control access to ConfigMaps, ensuring that only authorized entities can retrieve sensitive information.
  - Regularly review and audit RBAC policies to minimize the risk of unauthorized access.

- **Database Connection Pooling:**
  Implement database connection pooling to manage and optimize database connections, preventing potential security threats related to resource exhaustion.

- **Regular Security Audits:**
  - Conduct regular security audits and vulnerability assessments to identify and address potential security issues promptly.
  - Stay informed about security best practices and updates related to the technologies and frameworks used in the application.

### Known issues
- **Queue issues**
    The application will not function with more than one UI replica, however there is no time to fix this.
- **Hard-coded values**
    Due to time restraints and issues during development there are hard-coded values spread out over the code, such as database secrets. These should be made more secure if the service were to be put into real application.
- **User data is not encrypted**
    If the application were to actually be used, the user data in the User table neeeds to be encrypted.
- **Does not take into consideration common DB security threats**
    No active consideration to DoS/DDoS attacks, Malware, SQL/NoSQL injection attacks, etc. is made. This would likely require a lot more developemtn time however.


## Clone, Deploy and run
To setup the environment, clone the directory (change command if you do not use ssh)

    git clone git@github.com:ubk8751/taskmanager.git 

Run minikube by entering
    
    minikube start

int a terminal where you have access to minikube. Then set up the application by running
    
    ./run.sh [-c]

where the `-c` flag first cleans all deployments, services and configmaps that exists on your network, and tunnel into the application by running 

    minikube tunnel

The application should then be active on 

    localhost:5000

There it will ask you to log in, but you should not have an account available. Use the `Register` option to create a new user, then log in, which should provide you access to the taskmanager. There you can create and delete tasks.