-- kubectl -n river exec deploy/ksqldbcli -it -- bash
-- ksql http://ksqldbserver-external.river.svc.cluster.local:8088

SET 'auto.offset.reset' = 'earliest';

-- Show a new KStream of enriched orders
SELECT o.order_id AS order_identifier, AS_VALUE(o.order_id) AS order_id, o.customer_identifier,
c.first_name, c.last_name, c.email,
o.status, o.order_source, o.date_created, o.date_modified
FROM orders AS o
INNER JOIN customers AS c ON (o.customer_identifier = c.customer_identifier)
PARTITION BY o.order_id
EMIT CHANGES;

-- Send the resulting stream into a topic
INSERT INTO orders_enriched
SELECT o.order_id AS order_identifier, AS_VALUE(o.order_id) AS order_id, AS_VALUE(o.customer_id) AS customer_id,
(c.first_name) AS first_name, c.last_name AS last_name, c.email AS email,
o.status AS status, o.order_source AS order_source, o.date_created AS date_created, o.date_modified AS date_modified
FROM orders AS o
INNER JOIN customers AS c ON (o.customer_identifier = c.customer_identifier)
PARTITION BY o.order_id
EMIT CHANGES;