INSERT INTO publsh_informations (id, sdn_list_id, publish_date, record_count) VALUES (1, 1, '01/26/2007', '3311');
INSERT INTO program_lists (id, sdn_entry_id, program) VALUES (1, 1, 'CUBA');
INSERT INTO akas (id, aka_list_id, uid, attribute_type, category, last_name) VALUES (1, 1, '219', 'a.k.a.', 'strong', 'BNC');
INSERT INTO akas (id, aka_list_id, uid, attribute_type, category, last_name) VALUES (2, 1, '220', 'a.k.a.', 'strong', 'NATIONAL BANK\\\'S OF CUBA');
INSERT INTO aka_lists (id, sdn_entry_id) VALUES (1, 1);
INSERT INTO addresses (id, address_list_id, uid, address1, city, country) VALUES (1, 1, '199', 'Zweierstrasse 35', 'CH-8022 Zurich', 'Switzerland');
INSERT INTO address_lists (id, sdn_entry_id) VALUES (1, 1);
INSERT INTO sdn_entries (id, sdn_list_id, uid, last_name, sdn_type) VALUES (1, 1, '306', '\\\"BANCO\\\" NACIONAL DE CUBA', 'Entity');
INSERT INTO sdn_lists (id) VALUES (1);
