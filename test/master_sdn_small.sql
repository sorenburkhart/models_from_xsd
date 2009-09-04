INSERT INTO publsh_informations (id, sdn_list_id, record_count, publish_date) VALUES (1, 1, '3311', '01/26/2007');
INSERT INTO program_lists (id, sdn_entry_id, program) VALUES (1, 1, 'CUBA');
INSERT INTO akas (id, aka_list_id, category, uid, last_name, attribute_type) VALUES (1, 1, 'strong', '219', 'BNC', 'a.k.a.');
INSERT INTO akas (id, aka_list_id, category, uid, last_name, attribute_type) VALUES (2, 1, 'strong', '220', 'NATIONAL BANK\\\'S OF CUBA', 'a.k.a.');
INSERT INTO aka_lists (id, sdn_entry_id) VALUES (1, 1);
INSERT INTO addresses (id, address_list_id, city, address1, country, uid) VALUES (1, 1, 'CH-8022 Zurich', 'Zweierstrasse 35', 'Switzerland', '199');
INSERT INTO address_lists (id, sdn_entry_id) VALUES (1, 1);
INSERT INTO sdn_entries (id, sdn_list_id, uid, last_name, sdn_type) VALUES (1, 1, '306', '\\\"BANCO\\\" NACIONAL DE CUBA', 'Entity');
INSERT INTO sdn_lists (id) VALUES (1);
