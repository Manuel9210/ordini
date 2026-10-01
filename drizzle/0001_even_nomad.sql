ALTER TABLE `files` ADD `document_group` text DEFAULT 'Generale' NOT NULL;--> statement-breakpoint
ALTER TABLE `order_items` ADD `delivered_quantity` integer DEFAULT 0 NOT NULL;--> statement-breakpoint
UPDATE `order_items` SET `delivered_quantity`=`quantity` WHERE `delivered`=1;--> statement-breakpoint
ALTER TABLE `orders` ADD `completed_at` text;--> statement-breakpoint
UPDATE `orders` SET `completed_at`=`updated_at`
WHERE EXISTS (SELECT 1 FROM `order_items` WHERE `order_items`.`order_id`=`orders`.`id`)
AND NOT EXISTS (SELECT 1 FROM `order_items` WHERE `order_items`.`order_id`=`orders`.`id` AND `order_items`.`delivered_quantity` < `order_items`.`quantity`);
