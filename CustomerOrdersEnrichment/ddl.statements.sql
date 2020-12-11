-- kubectl -n river exec deploy/ksqldbcli -it -- bash
-- ksql http://ksqldbserver-external.river.svc.cluster.local:8088

-- Creating the customers table using Schema Inference
CREATE TABLE customers (
    customer_identifier INT PRIMARY KEY
  ) WITH (
    KAFKA_TOPIC = 'estreams75.ecommerce.customers',
    VALUE_FORMAT='AVRO'
);

-- Creating the orders stream using Schema Inference
CREATE STREAM orders (
    customer_identifier INT KEY
  ) WITH (
    KAFKA_TOPIC = 'estreams75.ecommerce.orders',
    VALUE_FORMAT='AVRO'
);


-- Creating the orders stream using Schema Inference
CREATE STREAM orders_enriched (
    order_identifier BIGINT KEY,
    order_id BIGINT,
    customer_id INT,
    first_name VARCHAR,
    last_name VARCHAR,
    email VARCHAR,
    status VARCHAR,
    order_source VARCHAR,
    date_created BIGINT,
    date_modified STRING
  ) WITH (
    KAFKA_TOPIC = 'estreams75.ecommerce.orders_enriched_ksql',
    VALUE_FORMAT='AVRO',
    PARTITIONS=5,
    REPLICAS=3
);