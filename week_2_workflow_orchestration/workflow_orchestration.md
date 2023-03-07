## Introduction to Workflow orchestration

**Workflow orchestration** governing data flow in a way that respects:
- orchestration rules and 
- your business logic.

**Data flow** -  is what binds and otherwise disparate set of applications together (connect different set of applications together).


**Workflow orchestration tool** allow to turn any code into a workflow that you can *schedule*, *run* and *observe*.

### Compare with Delivery service
![Workflow orchestration](https://github.com/DreadYo/data-engineering-zoomcamp/blob/master/images/workflow_orchestration.png)

- Each order in the shopping cart = Workflow
- Each delivery = Workflow Run
- Boxes with products = tasks inside workflow
- Different addresses = different DW or DB
- Type of delivery (individually or all orders together) = Config execution for tasks
- Wrap packaging = packaged into a sub-process, Docker container or Kubernetes job

### Core features of workflow orchestration tool
- Remote Execution
- Scheduling
- Retries
- Caching
- Integration with external systems (APIs, dbs)
- Ad-hoc runs
- Parameterization
- Alerts you when something fails