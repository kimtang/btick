# Btick

Btick is another kdb+ tick system. It incorporates as many best practices as possible with focus on extensibility, maintainability, performance, process management and diagnostic information. This platform will be suitable for those people looking to create a new kdb+ system. 

Btick is implemented very modular so it is very easy to be extended and modified as required. Also it uses a programming design pattern called 'behavioral design patterns' to unified the implementation. See https://github.com/kimtang/behaviourTag.

The features of btick will include but not limited by:

Process Management tool: btick will contain several smaller micro processes. And each micro process will have a name and a subsystem to belong to. 

Code Management Behaviour: Each process can optionally load common or process type/name specific code bases. All code loading is error trapped.

Usage Behaviour: All Hdbs and Rdbs will log their synchronous and asynchronous queries from user to an admin subsystem. This is then later used to understand how the platform is used. So people can react to it.

Heartbeating: each process will publish heartbeats and their health data to the admin subsystem.


## Install and requirement

