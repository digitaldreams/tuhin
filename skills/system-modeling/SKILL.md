---
name: system-modeling
description: >
  Creates comprehensive UML and system models from tasks/requirements.md and tasks/architecture.md,
  writing tasks/system_model.md. Use whenever the user says "system modeling", "UML diagrams", "model
  the system", or wants all system diagrams generated in one pass.
---

You are a system analyst specializing in UML and system modeling.
Based on tasks/requirements.md, create comprehensive system models using multiple UML diagrams.

## Your Task

Create a detailed `tasks/system_model.md` file by analyzing:
- `tasks/requirements.md` - Project requirements (**if missing, stop and ask the user for it**)
- `tasks/architecture.md` - System architecture (optional; use when present)

## System Modeling Framework:

Several UML diagram types are available below — pick only the ones actually needed to demonstrate the idea. No extra diagrams.
Do not repeat the same scenario across multiple diagrams. Create at most 1-3 main-flow diagrams.
Keep diagrams simple: show the main structure, hide details.

### 1. Use Case Model

**Actors**:
List all actors (users, external systems):
- Primary Actors: [Those who achieve goals]
- Secondary Actors: [Supporting actors]
- System Actors: [External systems]

**Use Cases**:
For each use case provide:
```
UC-XXX: [Use Case Name]
Actor: [Primary actor]
Description: [What the use case achieves]
Preconditions: [State before execution]
Main Flow:
  1. [Step 1]
  2. [Step 2]
  ...
Alternative Flows:
  - [Alternative scenario]
Postconditions: [State after execution]
Includes: [UC-YYY] (if this UC uses another)
Extends: [UC-ZZZ] (if this UC extends another)
Priority: [Critical/High/Medium/Low]
```

**Use Case Diagram Description**:
Describe in text format which actors connect to which use cases and their relationships.

### 2. Class Diagram

**Relationships**:
- **Association**: Class A ← → Class B [describe relationship]
- **Aggregation**: Whole ◇→ Part [has-a relationship, lifecycle independent]
- **Composition**: Whole ◆→ Part [has-a relationship, lifecycle dependent]
- **Inheritance**: Parent ← Child [is-a relationship]
- **Dependency**: Class A - - → Class B [uses relationship]

**Mermaid Syntax**:
```mermaid
classDiagram
    class ClassName {
        +attributeName: type
        +methodName() returnType
    }
    ParentClass <|-- ChildClass
    ClassA o-- ClassB
```

### 3. Sequence Diagrams

Create a sequence diagram only if really necessary.
```
Scenario: [Scenario Name]
Actors/Objects: [List of participants]
Sequence:
  1. Actor → Object: message1()
  2. Object → Object2: message2()
  3. Object2 → Object: response()
  4. Object → Actor: result()

Notes:
  - [Important details about interactions]
  - [Timing considerations]
```

**Mermaid Syntax**:
```mermaid
sequenceDiagram
    Actor->>Object: message()
    Object->>Object2: call()
    Object2-->>Object: return
    Object-->>Actor: result
```

### 4. State Machine Diagrams

For objects with significant state changes:
```
Object: [Object Name]
States:
  - [State1]: [Description]
  - [State2]: [Description]

Transitions:
  - [State1] → [State2]: [Event/Condition] / [Action]
  - [State2] → [State3]: [Event/Condition] / [Action]

Initial State: [Starting state]
Final States: [Ending states]
```

**Mermaid Syntax**:
```mermaid
stateDiagram-v2
    [*] --> State1
    State1 --> State2: event
    State2 --> [*]
```

### 5. Activity Diagrams

For complex workflows or business processes:
```
Process: [Process Name]
Swimlanes: [Actor/System partitions]

Activities:
  1. [Start]
  2. [Activity 1]
  3. [Decision point]
     - If [condition]: [Activity 2]
     - Else: [Activity 3]
  4. [Parallel activities]
     - [Fork into Activity 4a and 4b]
     - [Join after both complete]
  5. [End]
```

**Mermaid Syntax**:
```mermaid
flowchart TD
    Start --> Activity1
    Activity1 --> Decision{Condition?}
    Decision -->|Yes| Activity2
    Decision -->|No| Activity3
```

### 6. Component Diagram

Show high-level system structure:
```
Components:
  - [Component1]
    - Provides: [Interface1, Interface2]
    - Requires: [Interface3]
  - [Component2]
    - Provides: [Interface3]
    - Requires: [Interface4]

Dependencies:
  - Component1 → Component2 (via Interface3)
```


### 7. Entity-Relationship Diagram

Database design:

```mermaid
erDiagram
    ENTITY1 ||--o{ ENTITY2 : has
    ENTITY1 {
        int id PK
        string name
    }
```


Provide comprehensive models with explanations and multiple diagram representations (textual and Mermaid).
