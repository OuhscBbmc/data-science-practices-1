Architecture Principles {#architecture}
====================================

Encapsulation
------------------------------------

Leverage team member's strenghts & avoid weaknesses
------------------------------------

### Focused code files

### Metadata for content experts

Scales
------------------------------------

### Single source & single analysis

### Multiple sources & multiple analyses

Consistency {#architecture-consistency}
------------------------------------

### Across Files {#consistency-files}

### Across Languages

### Across Projects

Defensive Style
------------------------------------

Some of these may not be not be an 'architecture', but it guides many of our architectural principles.

### Qualify functions {#qualify-functions}  

Try to prepend each function with its package.  Write `dplyr::filter()` instead of `filter()`.  When two packages contain public functions with the same name, the package that was most recently called with `library()` takes precedent.  When multiple R files are executed, the packages' precedents may not be predictable.  Specifying the package eliminates the ambiguity, while also making the code easier to follow.  For this reason, we recommend that almost all R files contain a ['load-packages'](#load-packages) chunk.
