CREATE TABLE `activity_executions` (
  `activity_execution_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `worker` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `method` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `arguments` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`activity_execution_id`),
  KEY `index_activity_executions_on_worker_and_method_and_arguments` (`worker`,`method`,`arguments`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `address_api_responses` (
  `address_api_response_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `arguments` text COLLATE utf8_unicode_ci NOT NULL,
  `response` text COLLATE utf8_unicode_ci NOT NULL,
  `api_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`address_api_response_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `address_request_expirations` (
  `address_request_expiration_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `address_request_id` bigint(20) NOT NULL,
  `duration_hit_hours` int(11) NOT NULL,
  `duration_limit_hours` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`address_request_expiration_id`),
  UNIQUE KEY `index_address_request_expirations_on_address_request_id` (`address_request_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `address_request_pollings` (
  `address_request_polling_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `address_request_id` bigint(20) NOT NULL,
  `previous_address_request_polling_id` bigint(20) DEFAULT NULL,
  `poll_date` datetime NOT NULL,
  `poll_index` int(11) NOT NULL,
  `latest` tinyint(1) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`address_request_polling_id`),
  KEY `index_address_request_pollings_on_address_request_id` (`address_request_id`),
  KEY `index_address_request_pollings_on_latest` (`latest`),
  KEY `address_req_polling_previous_idx` (`previous_address_request_polling_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `address_request_states` (
  `address_request_state_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `address_request_id` bigint(20) NOT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `latest` tinyint(1) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`address_request_state_id`),
  KEY `index_address_request_states_on_address_request_id` (`address_request_id`),
  KEY `index_address_request_states_on_latest` (`latest`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `address_requests` (
  `address_request_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `request_sender_user_id` bigint(20) NOT NULL,
  `request_recipient_user_id` bigint(20) NOT NULL,
  `app_id` bigint(20) NOT NULL,
  `address_request_medium` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `address_request_payload` text COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`address_request_id`),
  KEY `index_address_requests_on_sender_user_id` (`request_sender_user_id`),
  KEY `index_address_requests_on_recipient_user_id` (`request_recipient_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `address_responses` (
  `address_response_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `address_request_id` bigint(20) NOT NULL,
  `response_sender_user_id` bigint(20) NOT NULL,
  `response_source_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `response_source_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  `response_data` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`address_response_id`),
  KEY `index_address_responses_on_response_sender_user_id` (`response_sender_user_id`),
  KEY `index_address_responses_on_address_request_id` (`address_request_id`),
  KEY `address_response_source_idx` (`response_source_type`,`response_source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `api_keys` (
  `api_key_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `token` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `expires_at` datetime NOT NULL,
  `latest` tinyint(1) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`api_key_id`),
  KEY `index_api_keys_on_user_id` (`user_id`),
  KEY `index_api_keys_on_token` (`token`),
  KEY `index_api_keys_on_latest` (`latest`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `apps` (
  `app_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`app_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `card_collection_entries` (
  `card_collection_entry_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `card_design_id` bigint(20) NOT NULL,
  `source_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `source_id` bigint(20) NOT NULL,
  `app_id` bigint(20) NOT NULL,
  `collection_type` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`card_collection_entry_id`),
  UNIQUE KEY `card_collection_entry_unique_idx` (`card_design_id`,`app_id`,`collection_type`),
  KEY `index_card_collection_entries_on_card_design_id` (`card_design_id`),
  KEY `index_card_collection_entries_on_source_type_and_source_id` (`source_type`,`source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `card_designs` (
  `card_design_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `author_user_id` bigint(20) NOT NULL,
  `source_card_design_id` bigint(20) DEFAULT NULL,
  `app_id` bigint(20) NOT NULL,
  `design_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `top_caption` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `bottom_caption` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `top_caption_font_size` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `bottom_caption_font_size` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `original_full_photo_image_id` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  `composed_full_photo_image_id` bigint(20) NOT NULL,
  `edited_full_photo_image_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`card_design_id`),
  KEY `index_card_designs_on_author_user_id` (`author_user_id`),
  KEY `index_card_designs_on_source_card_design_id` (`source_card_design_id`),
  KEY `index_card_designs_on_original_full_photo_image_id` (`original_full_photo_image_id`),
  KEY `index_card_designs_on_composed_full_photo_image_id` (`composed_full_photo_image_id`),
  KEY `index_card_designs_on_edited_full_photo_image_id` (`edited_full_photo_image_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `card_images` (
  `card_image_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `author_user_id` bigint(20) NOT NULL,
  `app_id` bigint(20) NOT NULL,
  `uuid` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `width` int(11) NOT NULL,
  `height` int(11) NOT NULL,
  `orientation` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `image_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`card_image_id`),
  UNIQUE KEY `index_card_images_on_uuid` (`uuid`),
  KEY `index_card_images_on_author_user_id` (`author_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `card_order_states` (
  `card_order_state_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `card_order_id` bigint(20) NOT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `latest` tinyint(1) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`card_order_state_id`),
  KEY `index_card_order_states_on_card_order_id` (`card_order_id`),
  KEY `index_card_order_states_on_latest` (`latest`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `card_orders` (
  `card_order_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `order_sender_user_id` bigint(20) NOT NULL,
  `app_id` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  `quoted_total_price` int(11) NOT NULL,
  `card_design_id` bigint(20) NOT NULL,
  PRIMARY KEY (`card_order_id`),
  KEY `index_card_orders_on_sender_user_id` (`order_sender_user_id`),
  KEY `index_card_orders_on_card_design_id` (`card_design_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `card_preview_compositions` (
  `card_preview_composition_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `card_design_id` bigint(20) NOT NULL,
  `card_preview_image_id` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`card_preview_composition_id`),
  KEY `index_card_preview_compositions_on_card_design_id` (`card_design_id`),
  KEY `index_card_preview_compositions_on_card_preview_image_id` (`card_preview_image_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `card_printing_compositions` (
  `card_printing_composition_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `card_printing_id` bigint(20) NOT NULL,
  `card_front_image_id` bigint(20) NOT NULL,
  `card_back_image_id` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`card_printing_composition_id`),
  KEY `index_card_printing_compositions_on_card_printing_id` (`card_printing_id`),
  KEY `index_card_printing_compositions_on_card_front_image_id` (`card_front_image_id`),
  KEY `index_card_printing_compositions_on_card_back_image_id` (`card_back_image_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `card_printing_states` (
  `card_printing_state_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `card_printing_id` bigint(20) NOT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `latest` tinyint(1) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`card_printing_state_id`),
  KEY `index_card_printing_states_on_card_printing_id` (`card_printing_id`),
  KEY `index_card_printing_states_on_latest` (`latest`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `card_printings` (
  `card_printing_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `card_order_id` bigint(20) NOT NULL,
  `recipient_user_id` bigint(20) NOT NULL,
  `print_number` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`card_printing_id`),
  KEY `index_card_printings_on_card_order_id` (`card_order_id`),
  KEY `index_card_printings_on_recipient_user_id` (`recipient_user_id`),
  KEY `index_card_printings_on_print_number` (`print_number`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `card_scan_authors` (
  `card_scan_author_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `card_scan_id` bigint(20) NOT NULL,
  `author_user_id` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`card_scan_author_id`),
  KEY `index_card_scan_authors_on_card_scan_id` (`card_scan_id`),
  KEY `index_card_scan_authors_on_author_user_id` (`author_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `card_scans` (
  `card_scan_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `card_printing_id` bigint(20) NOT NULL,
  `app_id` bigint(20) NOT NULL,
  `scanned_at` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`card_scan_id`),
  KEY `index_card_scans_on_card_printing_id` (`card_printing_id`),
  KEY `index_card_scans_on_scanned_at` (`scanned_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `facebook_token_states` (
  `facebook_token_state_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `facebook_token_id` bigint(20) NOT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `latest` tinyint(1) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`facebook_token_state_id`),
  KEY `index_facebook_token_states_on_facebook_token_id` (`facebook_token_id`),
  KEY `index_facebook_token_states_on_latest` (`latest`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `facebook_tokens` (
  `facebook_token_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `token` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`facebook_token_id`),
  KEY `index_facebook_tokens_on_user_id` (`user_id`),
  KEY `index_facebook_tokens_on_token` (`token`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `recipient_addresses` (
  `recipient_address_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `recipient_user_id` bigint(20) NOT NULL,
  `address_api_response_id` bigint(20) NOT NULL,
  `latest` tinyint(1) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  `address_request_id` bigint(20) NOT NULL,
  PRIMARY KEY (`recipient_address_id`),
  KEY `index_recipient_addresses_on_recipient_user_id` (`recipient_user_id`),
  KEY `index_recipient_addresses_on_address_api_response_id` (`address_api_response_id`),
  KEY `index_recipient_addresses_on_latest` (`latest`),
  KEY `index_recipient_addresses_on_address_request_id` (`address_request_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `stripe_cards` (
  `stripe_card_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `exp_month` int(11) NOT NULL,
  `exp_year` int(11) NOT NULL,
  `fingerprint` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `last4` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `card_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`stripe_card_id`),
  UNIQUE KEY `index_stripe_cards_on_fingerprint_and_exp_month_and_exp_year` (`fingerprint`,`exp_month`,`exp_year`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `stripe_customer_card_states` (
  `stripe_customer_card_state_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `stripe_customer_card_id` bigint(20) NOT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `latest` tinyint(1) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`stripe_customer_card_state_id`),
  KEY `index_stripe_customer_card_states_on_stripe_customer_card_id` (`stripe_customer_card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `stripe_customer_cards` (
  `stripe_customer_card_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `stripe_customer_id` bigint(20) NOT NULL,
  `stripe_card_id` bigint(20) NOT NULL,
  `latest` tinyint(1) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`stripe_customer_card_id`),
  KEY `index_stripe_customer_cards_on_stripe_customer_id` (`stripe_customer_id`),
  KEY `index_stripe_customer_cards_on_stripe_card_id` (`stripe_card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `stripe_customers` (
  `stripe_customer_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `latest` tinyint(1) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  `stripe_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`stripe_customer_id`),
  KEY `index_stripe_customers_on_user_id` (`user_id`),
  KEY `index_stripe_customers_on_stripe_customer_id` (`stripe_customer_id`),
  KEY `index_stripe_customers_on_latest` (`latest`),
  KEY `index_stripe_customers_on_stripe_id` (`stripe_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `transaction_line_items` (
  `transaction_line_item_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `transaction_id` bigint(20) NOT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `price_units` int(11) NOT NULL,
  `currency` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `is_credit` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`transaction_line_item_id`),
  KEY `index_transaction_line_items_on_transaction_id` (`transaction_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `transactions` (
  `transaction_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `card_order_id` bigint(20) NOT NULL,
  `charged_customer_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `charged_customer_id` bigint(20) NOT NULL,
  `response` text COLLATE utf8_unicode_ci NOT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`transaction_id`),
  KEY `index_transactions_on_card_order_id` (`card_order_id`),
  KEY `transaction_customer_idx` (`charged_customer_type`,`charged_customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `user_logins` (
  `user_login_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `app_id` bigint(20) NOT NULL,
  `latest` tinyint(1) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`user_login_id`),
  KEY `index_user_logins_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `user_profiles` (
  `user_profile_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `first_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `location` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `middle_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `birthday` datetime DEFAULT NULL,
  `gender` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `latest` tinyint(1) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`user_profile_id`),
  KEY `index_user_profiles_on_user_id` (`user_id`),
  KEY `index_user_profiles_on_name` (`name`),
  KEY `index_user_profiles_on_last_name` (`last_name`),
  KEY `index_user_profiles_on_email` (`email`),
  KEY `index_user_profiles_on_latest` (`latest`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `users` (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `facebook_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `index_users_on_facebook_id` (`facebook_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO schema_migrations (version) VALUES ('20130201080909');

INSERT INTO schema_migrations (version) VALUES ('20130201082700');

INSERT INTO schema_migrations (version) VALUES ('20130201093522');

INSERT INTO schema_migrations (version) VALUES ('20130201093850');

INSERT INTO schema_migrations (version) VALUES ('20130201094114');

INSERT INTO schema_migrations (version) VALUES ('20130201094452');

INSERT INTO schema_migrations (version) VALUES ('20130201194102');

INSERT INTO schema_migrations (version) VALUES ('20130201194314');

INSERT INTO schema_migrations (version) VALUES ('20130201194517');

INSERT INTO schema_migrations (version) VALUES ('20130201195647');

INSERT INTO schema_migrations (version) VALUES ('20130201195832');

INSERT INTO schema_migrations (version) VALUES ('20130201200023');

INSERT INTO schema_migrations (version) VALUES ('20130201200200');

INSERT INTO schema_migrations (version) VALUES ('20130201200650');

INSERT INTO schema_migrations (version) VALUES ('20130201201301');

INSERT INTO schema_migrations (version) VALUES ('20130201201530');

INSERT INTO schema_migrations (version) VALUES ('20130201210207');

INSERT INTO schema_migrations (version) VALUES ('20130201211029');

INSERT INTO schema_migrations (version) VALUES ('20130201211222');

INSERT INTO schema_migrations (version) VALUES ('20130201220616');

INSERT INTO schema_migrations (version) VALUES ('20130201220913');

INSERT INTO schema_migrations (version) VALUES ('20130201221244');

INSERT INTO schema_migrations (version) VALUES ('20130201221451');

INSERT INTO schema_migrations (version) VALUES ('20130201222100');

INSERT INTO schema_migrations (version) VALUES ('20130201222919');

INSERT INTO schema_migrations (version) VALUES ('20130201225054');

INSERT INTO schema_migrations (version) VALUES ('20130202000801');

INSERT INTO schema_migrations (version) VALUES ('20130207015553');

INSERT INTO schema_migrations (version) VALUES ('20130207021025');

INSERT INTO schema_migrations (version) VALUES ('20130207055445');

INSERT INTO schema_migrations (version) VALUES ('20130207205907');

INSERT INTO schema_migrations (version) VALUES ('20130208004347');

INSERT INTO schema_migrations (version) VALUES ('20130209031219');

INSERT INTO schema_migrations (version) VALUES ('20130212072043');

INSERT INTO schema_migrations (version) VALUES ('20130212074734');

INSERT INTO schema_migrations (version) VALUES ('20130212101646');

INSERT INTO schema_migrations (version) VALUES ('20130212104621');

INSERT INTO schema_migrations (version) VALUES ('20130212105206');

INSERT INTO schema_migrations (version) VALUES ('20130212110533');

INSERT INTO schema_migrations (version) VALUES ('20130212111110');

INSERT INTO schema_migrations (version) VALUES ('20130212112802');

INSERT INTO schema_migrations (version) VALUES ('20130213001128');

INSERT INTO schema_migrations (version) VALUES ('20130213002328');

INSERT INTO schema_migrations (version) VALUES ('20130219100148');

INSERT INTO schema_migrations (version) VALUES ('20130219190424');

INSERT INTO schema_migrations (version) VALUES ('20130220022631');