#!/bin/bash
export pass=`grep OPENMRS_DB_PASSWORD /etc/bahmni-installer/bahmni.conf |cut -f 2 -d =`

mysql -uroot -p${pass} openmrs << EOF
start transaction;
update idgen_seq_id_gen set next_sequence_value = '001';
update idgen_seq_id_gen set prefix = Concat(substring(now(), 3, 2),substring(now(),6,2));
update idgen_seq_id_gen set first_identifier_base = '001';
commit;
EOF

ret=$?

if [ ${ret} == 0 ]; then
 echo "Successfully updated Identifier" >> /var/log/id.txt
else
 echo "Failed to update Identifier" >> /var/log/id.txt
fi

exit ${ret}
