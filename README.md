# 🔍 DIGITAL NARRATIVE EXPLORER

## 📄 INTRODUCTION

**_Digital Narrative Explorer db_** is result of a two-month internship of Anežka Formánková and Bc. Anna Kovaříková under mag Mattia Bellini for COST Action INDCOR (Interactive Narrative Design for Complexity Representations) project, particularly, the _Interactive digital platform to enable the public dissemination of the results of the Action_ deliverable.

Currently, four files with the data for the database, and a code for creation of the database with Neo4j Cypher have been compiled. Other files contain extended documentation and report on the actions and directions taken during the internship as well as our propositions for future work, such as an interactive web application, powered by the database.

### ⚙️ TOOLS USED

The tools that have been used for this project are the following:

- `Python 3.7.0` and its libraries `uuid`,`regex`,
- `Neo4j Kernel 5.12.0`, enterprise edition,
- Neo4j Desktop application,
- Neo4j Database Management System,
- and CSV files, managed though VS Code with Rainbow CSV extension.

Python, regex library and VS Code have been used for structuring the data and easier manipulation with them. Uuid library has been used for generating a unique identifier for each entity. Neo4j and its query language Cypher have been used to create a graph from the CSV data in the local DBMS (which is described in the Neo4j documentation as _“capable of containing and managing multiple graphs contained in databases. Client applications will connect to the DBMS and open sessions against it. A client session provides access to any graph in the DBMS”_.

## 🗃️ DATABASE

### 🗂️ DATABASE ARCHITECTURE

#### 🗄️ DATA STORING

Currently, the database consists of the data formatted as CSV and converted into a graph database (so far only in local DBMS) through the Neo4j Desktop application.

As of currently, there is 4 CSV files:

- `concepts_node_list.CSV`
- `segments_node_list.CSV`
- `persons_node_list.CSV`
- `edge_list.CSV`

Given the lack of the “custom sections” for most of the Concepts, as of time of creating this database, file custom_sections.CSV has not been created, but its setup is advised for future collaborators.

All nodes list files contain the information about individual nodes and their properties 


#### DATABASE ARCHITECTURE

![Model of Node labels and properties](\nodes.png)

_Model of Node labels and properties_

The database contains the following node types: **Person**, **Concept**, **Definition**, **Explication**, and **History** (**Custom Section** has been omitted for aforementioned reasons, but we kept it in the illustration for integrity). All node types have a unique _identifier_ property that serves as the node's primary key. All IDs have been randomly generated through the Python uuid library with uuid4.

Person nodes also contain property _name_, in the form of a string, and in case of a contact person role, also contact information. Concept node also has a property _name_, and then a list of _alternative names_ (if it has any) as semicolon separated values, that Neo4j can split and create a list. We would also advise to add the property of "tags" or "keywords" in the future, once the Encyclopedia has been completed.

Node type Definition, Explication, History and Custom Section only have one other property, apart from ID, which is _text_. Text property would contain uri to another database storing the full texts of given sections from which the text could be retrieved when called upon with the uri.

The edge list file contains the information about the relationships between all the nodes, stored as a list of source-target values. Sources and targets in this list are all represented by their unique ID. Third column contains the information about the type of relationship. Graph database software can then represent the relationships as shown in Figure 6.


![Small instance model](\small_instance_model.png)
_Small instance model_

<br>

![Large instance model](\large_instance_model.png)
_Full instance model_


Currently (as of 11.5.2024) the database has been designed to only deal with data from IDN Encyclopedia, which is currently in the process of being written and is planned to be completed by the end of the year. Database could of course be expanded by further sources (like conference proceedings) and thus be enriched by more nodes. Expanding the database would lead to conceptualization of more nodes and relationships in a similar way to IDN Encyclopedia nodes. Further node Sources could be added, which would become the top-most nodes of all the added nodes and relationships from the given source.

### 💻 RUNNING THE PROGRAM

The following code was used for loading the database into the local DBMS (database management system) via the Neo4j Desktop application.


	LOAD CSV WITH HEADERS FROM 'file:///path//to/your//import//concepts_node_list.CSV' AS row

	CALL apoc.merge.node (\[row.type\], {id: row.id, taxonomyNumber: row.taxonomy_number, name: row.name, alternativeNames :coalesce(split(row.alternative_names, ";"), "-") })

	YIELD node RETURN node

<br>

	LOAD CSV WITH HEADERS FROM 'file:///path//to/your//import//persons_node_list.CSV' AS row

	CALL apoc.merge.node (\[row.type\], {id: row.id, name: row.name}) YIELD node RETURN node

<br>

	LOAD CSV WITH HEADERS FROM 'file:///path//to/your//import//segments_node_list.CSV' AS row

	CALL apoc.merge.node(\[row.type\], {id: row.id, text: row.text}) YIELD node RETURN node

<br>


	LOAD CSV WITH HEADERS FROM 'file:///path//to/your//import//edge_list.CSV' AS row

	MATCH (n), (m)

	WHERE n.id = row.source AND m.id = row.target

	CALL apoc.merge.relationship(n, row.relationship, {}, {}, m) YIELD rel

	RETURN count(\*)

Where `'path//to//your//import//concepts_node_list.CSV'` is replaced by your true path to Neo4j imports and for files concepts_node_list.CSV, segments_node_list.CSV, persons_node_list.CSV and edge_list.CSV.

<br>

![IDN Encyclopedia graph](\graph_database.png)
_IDN Encyclopedia graph_


## 🔮 FUTURE WORK

The code does not establish the properties of the relationship `WROTE` for some authors, that would indicate that they are a Contact Person (because as of writing this documentation, the Encyclopedia has not been finished yet and so, the authorship of some nodes may change or expand). It also does not create any CustomSections, because there has been only one Concept with Custom Section as of the time of writing.

The current hope is for IDN Encyclopedia concepts to be one of many “introductory nodes” presented to the user. Future expansion of the database might include conference proceedings, white papers, books and more, produced by the INDCOR COST action project. The mining of the data from these materials will follow a similar process – drafting of the use cases, identifying the possible entities (nodes), their properties and the relationships that connect them, and then creating structured documents that follow this structure. Each data source will need a tailor-made solution (since they contain different types of data and have different structures).

