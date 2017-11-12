alter table contract_based drop foreign key contract_based_ibfk_2;
alter table contract_based add foreign key (cid) references contracts (cid) on delete cascade on update cascade;


alter table contract_payment drop foreign key contract_payment_ibfk_2;
alter table contract_payment add foreign key (cid) references contracts (cid);


alter table demotion drop foreign key demotion_ibfk_2;
alter table demotion add foreign key (lower_pid, lower_uid) references post (pid, uid) on delete no action on update cascade;
alter table demotion drop foreign key demotion_ibfk_3;
alter table demotion add foreign key (higher_pid, higher_uid) references post (pid, uid) on delete no action on update cascade;

alter table employee_post drop foreign key employee_post_ibfk_2;
alter table employee_post add foreign key (pid, uid) references post (pid, uid) on update cascade;

alter table initial_pay_scale drop foreign key initial_pay_scale_ibfk_1;
alter table initial_pay_scale add foreign key (pid, uid) references post (pid, uid) on delete cascade on update cascade;

alter table orders_placed drop foreign key orders_placed_ibfk_2;
alter table orders_placed add foreign key (oid) references orders(oid) on delete cascade on update cascade;

alter table payment_loan drop foreign key payment_loan_ibfk_2;
alter table payment_loan add foreign key (lid) references loan(lid) on delete cascade on update cascade;

alter table post drop foreign key post_ibfk_1;
alter table post add foreign key (uid) references ulb(uid) on delete cascade on update cascade;

alter table promotion drop foreign key promotion_ibfk_2;
alter table promotion add foreign key (lower_pid, lower_uid) references post (pid, uid) on delete no action on update cascade;
alter table promotion drop foreign key promotion_ibfk_3;
alter table promotion add foreign key (higher_pid, higher_uid) references post (pid, uid) on delete no action on update cascade;

alter table regularisation drop foreign key regularisation_ibfk_2;
alter table regularisation add foreign key (pid, uid) references post (pid, uid) on delete no action on update cascade;
