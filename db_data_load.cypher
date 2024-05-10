LOAD CSV WITH HEADERS FROM 'file:///path//to//your//import//concepts_node_list.csv' AS row
CALL apoc.merge.node ([row.type], {id: row.id, taxonomyNumber: row.taxonomy_number, name: row.name, alternativeNames :coalesce(split(row.alternative_names, ";"), "-") }) YIELD node RETURN node



LOAD CSV WITH HEADERS FROM 'path//to//your//import//persons_node_list.csv' AS row
CALL apoc.merge.node ([row.type], {id: row.id, name: row.name}) YIELD node RETURN node


LOAD CSV WITH HEADERS FROM 'file:///path//to//your//import//segments_node_list.csv' AS row
CALL apoc.merge.node([row.type], {id: row.id, text: row.text}) YIELD node RETURN node


LOAD CSV WITH HEADERS FROM 'file:///path//to//your//import//edge_list.csv' AS row
MATCH (n), (m)
WHERE n.id = row.source AND m.id = row.target
CALL apoc.merge.relationship(n, row.relationship, {}, {}, m) YIELD rel
RETURN count(*)
