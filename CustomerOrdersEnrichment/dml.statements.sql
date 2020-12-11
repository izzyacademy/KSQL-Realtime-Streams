
SET 'auto.offset.reset' = 'earliest';

-- Show a new KStream of enriched orders
SELECT o.order_id, o.customer_identifier,
c.first_name, c.last_name, c.email,
o.status, o.order_source, o.date_created, o.date_modified
FROM orders AS o
INNER JOIN customers AS c ON (o.customer_identifier = c.customer_identifier)
PARTITION BY o.order_id
EMIT CHANGES;

-- Send the resulting stream into a topic
INSERT INTO orders_enriched
SELECT o.order_id, o.customer_identifier,
c.first_name, c.last_name, c.email,
o.status, o.order_source, o.date_created, o.date_modified
FROM orders AS o
INNER JOIN customers AS c ON (o.customer_identifier = c.customer_identifier)
PARTITION BY o.order_id
EMIT CHANGES;