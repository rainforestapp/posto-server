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
  `response` text COLLATE utf8_unicode_ci NOT NULL,
  `api_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  `arguments` varchar(512) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`address_api_response_id`),
  KEY `index_address_api_responses_on_arguments` (`arguments`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `address_request_facebook_threads` (
  `address_request_facebook_thread_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `address_request_id` bigint(20) NOT NULL,
  `facebook_thread_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `thread_update_time` datetime NOT NULL,
  `latest` tinyint(1) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`address_request_facebook_thread_id`),
  KEY `index_address_request_facebook_threads_on_facebook_thread_id` (`facebook_thread_id`)
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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
  `sender_supplied_address_api_response_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`address_request_id`),
  KEY `index_address_requests_on_sender_user_id` (`request_sender_user_id`),
  KEY `index_address_requests_on_recipient_user_id` (`request_recipient_user_id`)
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `apps` (
  `app_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  `domain` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `apple_app_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`app_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `aps_tokens` (
  `aps_token_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `app_id` bigint(20) NOT NULL,
  `token` varchar(512) COLLATE utf8_unicode_ci NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`aps_token_id`),
  KEY `index_aps_tokens_on_token` (`token`(255)),
  KEY `index_aps_tokens_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `birthday_request_facebook_threads` (
  `birthday_request_facebook_thread_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `birthday_request_id` bigint(20) NOT NULL,
  `facebook_thread_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `thread_update_time` datetime NOT NULL,
  `latest` tinyint(1) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`birthday_request_facebook_thread_id`),
  KEY `index_birthday_request_facebook_threads_on_birthday_request_id` (`birthday_request_id`),
  KEY `index_birthday_request_facebook_threads_on_facebook_thread_id` (`facebook_thread_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `birthday_request_responses` (
  `birthday_request_response_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `birthday_request_id` bigint(20) DEFAULT NULL,
  `recipient_user_id` bigint(20) NOT NULL,
  `sender_user_id` bigint(20) NOT NULL,
  `birthday` datetime NOT NULL,
  `latest` tinyint(1) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`birthday_request_response_id`),
  KEY `index_birthday_request_responses_on_birthday_request_id` (`birthday_request_id`),
  KEY `index_birthday_request_responses_on_recipient_user_id` (`recipient_user_id`),
  KEY `index_birthday_request_responses_on_sender_user_id` (`sender_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `birthday_request_states` (
  `birthday_request_state_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `birthday_request_id` bigint(20) NOT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `latest` tinyint(1) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`birthday_request_state_id`),
  KEY `index_birthday_request_states_on_birthday_request_id` (`birthday_request_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `birthday_requests` (
  `birthday_request_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `request_sender_user_id` bigint(20) NOT NULL,
  `request_recipient_user_id` bigint(20) NOT NULL,
  `app_id` bigint(20) NOT NULL,
  `birthday_request_medium` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `birthday_request_payload` text COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`birthday_request_id`),
  KEY `index_birthday_requests_on_request_sender_user_id` (`request_sender_user_id`),
  KEY `index_birthday_requests_on_request_recipient_user_id` (`request_recipient_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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
  `stock_design_id` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `note` varchar(1024) COLLATE utf8_unicode_ci DEFAULT NULL,
  `photo_is_user_generated` tinyint(1) DEFAULT NULL,
  `postcard_subject_json` varchar(4096) COLLATE utf8_unicode_ci DEFAULT NULL,
  `frame_type` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `photo_taken_at` datetime DEFAULT NULL,
  PRIMARY KEY (`card_design_id`),
  KEY `index_card_designs_on_author_user_id` (`author_user_id`),
  KEY `index_card_designs_on_source_card_design_id` (`source_card_design_id`),
  KEY `index_card_designs_on_original_full_photo_image_id` (`original_full_photo_image_id`),
  KEY `index_card_designs_on_composed_full_photo_image_id` (`composed_full_photo_image_id`),
  KEY `index_card_designs_on_edited_full_photo_image_id` (`edited_full_photo_image_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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
  `image_format` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`card_image_id`),
  UNIQUE KEY `index_card_images_on_uuid` (`uuid`),
  KEY `index_card_images_on_author_user_id` (`author_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `card_order_credit_allocations` (
  `card_order_credit_allocation_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `card_order_id` bigint(20) NOT NULL,
  `credits_per_card` int(11) NOT NULL,
  `credits_per_order` int(11) NOT NULL,
  `number_of_credited_cards` int(11) NOT NULL,
  `latest` tinyint(1) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`card_order_credit_allocation_id`),
  KEY `index_card_order_credit_allocations_on_card_order_id` (`card_order_id`),
  KEY `index_card_order_credit_allocations_on_card_order_id_and_latest` (`card_order_id`,`latest`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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
  `uid` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `days_until_share` int(11) DEFAULT NULL,
  `is_promo` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`card_order_id`),
  UNIQUE KEY `index_card_orders_on_uid` (`uid`),
  KEY `index_card_orders_on_sender_user_id` (`order_sender_user_id`),
  KEY `index_card_orders_on_card_design_id` (`card_design_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `card_preview_compositions` (
  `card_preview_composition_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `card_design_id` bigint(20) NOT NULL,
  `card_preview_image_id` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  `latest` tinyint(1) NOT NULL,
  `treated_card_preview_image_id` bigint(20) NOT NULL,
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
  `latest` tinyint(1) NOT NULL,
  `jpg_card_front_image_id` bigint(20) NOT NULL,
  `jpg_card_back_image_id` bigint(20) NOT NULL,
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
  `uid` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`card_printing_id`),
  UNIQUE KEY `index_card_printings_on_uid` (`uid`),
  KEY `index_card_printings_on_card_order_id` (`card_order_id`),
  KEY `index_card_printings_on_recipient_user_id` (`recipient_user_id`),
  KEY `index_card_printings_on_print_number` (`print_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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
  `scan_position` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `device_uuid` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `scanned_by_user_id` bigint(20) DEFAULT NULL,
  `latest` tinyint(1) NOT NULL,
  PRIMARY KEY (`card_scan_id`),
  KEY `index_card_scans_on_card_printing_id` (`card_printing_id`),
  KEY `index_card_scans_on_scanned_at` (`scanned_at`),
  KEY `index_card_scans_on_scanned_by_user_id` (`scanned_by_user_id`),
  KEY `index_card_scans_on_device_uuid` (`device_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `credit_journal_entries` (
  `credit_journal_entry_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `app_id` bigint(20) NOT NULL,
  `amount` int(11) NOT NULL,
  `source_type` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `source_id` varchar(8) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`credit_journal_entry_id`),
  KEY `index_credit_journal_entries_on_user_id` (`user_id`),
  KEY `index_credit_journal_entries_on_source_type_and_source_id` (`source_type`,`source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `credit_orders` (
  `credit_order_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `app_id` bigint(20) NOT NULL,
  `price` int(11) NOT NULL,
  `credits` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  `note` varchar(1024) COLLATE utf8_unicode_ci DEFAULT NULL,
  `gifter_person_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`credit_order_id`),
  KEY `index_credit_orders_on_user_id` (`user_id`),
  KEY `index_credit_orders_on_gifter_person_id` (`gifter_person_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `credit_plan_membership_states` (
  `credit_plan_membership_state_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `credit_plan_membership_id` bigint(20) NOT NULL,
  `state` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `latest` tinyint(1) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`credit_plan_membership_state_id`),
  KEY `index_credit_plan_membership_states_on_credit_plan_membership_id` (`credit_plan_membership_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `credit_plan_memberships` (
  `credit_plan_membership_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `app_id` bigint(20) NOT NULL,
  `credit_plan_id` bigint(20) NOT NULL,
  `credit_plan_credits` int(11) NOT NULL,
  `credit_plan_price` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`credit_plan_membership_id`),
  KEY `index_credit_plan_memberships_on_user_id` (`user_id`),
  KEY `index_credit_plan_memberships_on_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `credit_plan_payment_states` (
  `credit_plan_payment_state_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `credit_plan_payment_id` bigint(20) NOT NULL,
  `state` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `latest` tinyint(1) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`credit_plan_payment_state_id`),
  KEY `index_credit_plan_payment_states_on_credit_plan_payment_id` (`credit_plan_payment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `credit_plan_payments` (
  `credit_plan_payment_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `credit_plan_membership_id` bigint(20) NOT NULL,
  `due_date` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`credit_plan_payment_id`),
  KEY `index_credit_plan_payments_on_credit_plan_membership_id` (`credit_plan_membership_id`),
  KEY `index_credit_plan_payments_on_due_date` (`due_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `credit_promo_states` (
  `credit_promo_state_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `state` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `credit_promo_id` bigint(20) NOT NULL,
  `latest` tinyint(1) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`credit_promo_state_id`),
  KEY `index_credit_promo_states_on_credit_promo_id` (`credit_promo_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `credit_promos` (
  `credit_promo_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uid` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `granted_to_user_id` bigint(20) DEFAULT NULL,
  `credits` int(11) NOT NULL,
  `app_id` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`credit_promo_id`),
  KEY `index_credit_promos_on_uid` (`uid`),
  KEY `index_credit_promos_on_granted_to_user_id` (`granted_to_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `email_opt_out_states` (
  `email_opt_out_state_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email_opt_out_id` bigint(20) NOT NULL,
  `state` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `latest` tinyint(1) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`email_opt_out_state_id`),
  KEY `index_email_opt_out_states_on_email_opt_out_id` (`email_opt_out_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `email_opt_outs` (
  `email_opt_out_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `recipient_user_id` bigint(20) NOT NULL,
  `email_class` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`email_opt_out_id`),
  KEY `index_email_opt_outs_on_recipient_user_id` (`recipient_user_id`)
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `outgoing_email_task_states` (
  `outgoing_email_task_state_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `outgoing_email_task_id` bigint(20) NOT NULL,
  `state` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `latest` tinyint(1) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`outgoing_email_task_state_id`),
  KEY `index_outgoing_email_task_states_on_outgoing_email_task_id` (`outgoing_email_task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `outgoing_email_tasks` (
  `outgoing_email_task_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `workload_id` varchar(512) COLLATE utf8_unicode_ci NOT NULL,
  `uid` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `workload_index` int(11) NOT NULL,
  `email_type` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `email_variant` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `email_args` varchar(2048) COLLATE utf8_unicode_ci NOT NULL,
  `recipient_user_id` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  `app_id` bigint(20) NOT NULL,
  PRIMARY KEY (`outgoing_email_task_id`),
  KEY `index_outgoing_email_tasks_on_workload_id_and_workload_index` (`workload_id`(255),`workload_index`),
  KEY `index_outgoing_email_tasks_on_recipient_user_id` (`recipient_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `people` (
  `person_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email` varchar(512) COLLATE utf8_unicode_ci NOT NULL,
  `uid` varchar(512) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`person_id`),
  KEY `index_people_on_email` (`email`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `person_notification_preferences` (
  `person_notification_preference_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `person_id` bigint(20) DEFAULT NULL,
  `notification_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `target_id` bigint(20) DEFAULT NULL,
  `enabled` tinyint(1) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`person_notification_preference_id`),
  KEY `index_person_notification_preferences_on_person_id` (`person_id`),
  KEY `index_person_notification_preferences_on_target_id` (`target_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `person_profiles` (
  `person_profile_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `person_id` bigint(20) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `latest` tinyint(1) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`person_profile_id`),
  KEY `index_person_profiles_on_person_id` (`person_id`),
  KEY `index_person_profiles_on_person_id_and_latest` (`person_id`,`latest`),
  KEY `index_person_profiles_on_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `rails_admin_histories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` text COLLATE utf8_unicode_ci,
  `username` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `item` int(11) DEFAULT NULL,
  `table` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `month` smallint(6) DEFAULT NULL,
  `year` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_rails_admin_histories` (`item`,`table`,`month`,`year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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
  `birthday_day` int(11) DEFAULT NULL,
  `birthday_month` int(11) DEFAULT NULL,
  `birthday_year` int(11) DEFAULT NULL,
  PRIMARY KEY (`user_profile_id`),
  KEY `index_user_profiles_on_user_id` (`user_id`),
  KEY `index_user_profiles_on_name` (`name`),
  KEY `index_user_profiles_on_last_name` (`last_name`),
  KEY `index_user_profiles_on_email` (`email`),
  KEY `index_user_profiles_on_latest` (`latest`),
  KEY `index_user_profiles_on_birthday_day_and_birthday_month` (`birthday_day`,`birthday_month`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `user_referral_states` (
  `user_referral_state_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_referral_id` bigint(20) NOT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `latest` tinyint(1) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`user_referral_state_id`),
  KEY `index_user_referral_states_on_user_referral_id` (`user_referral_id`),
  KEY `index_user_referral_states_on_user_referral_id_and_latest` (`user_referral_id`,`latest`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `user_referrals` (
  `user_referral_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `referred_user_id` bigint(20) NOT NULL,
  `referring_user_id` bigint(20) NOT NULL,
  `app_id` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`user_referral_id`),
  KEY `index_user_referrals_on_referred_user_id` (`referred_user_id`),
  KEY `index_user_referrals_on_referring_user_id` (`referring_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `users` (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `facebook_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `meta` text COLLATE utf8_unicode_ci,
  `uid` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `signup_credits_awarded` tinyint(1) DEFAULT NULL,
  `sent_promo_card` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `index_users_on_facebook_id` (`facebook_id`),
  KEY `index_users_on_uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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

INSERT INTO schema_migrations (version) VALUES ('20130220231333');

INSERT INTO schema_migrations (version) VALUES ('20130221002548');

INSERT INTO schema_migrations (version) VALUES ('20130221020607');

INSERT INTO schema_migrations (version) VALUES ('20130221085535');

INSERT INTO schema_migrations (version) VALUES ('20130222164456');

INSERT INTO schema_migrations (version) VALUES ('20130223075260');

INSERT INTO schema_migrations (version) VALUES ('20130226010642');

INSERT INTO schema_migrations (version) VALUES ('20130226010904');

INSERT INTO schema_migrations (version) VALUES ('20130227011943');

INSERT INTO schema_migrations (version) VALUES ('20130228004524');

INSERT INTO schema_migrations (version) VALUES ('20130301003520');

INSERT INTO schema_migrations (version) VALUES ('20130302183141');

INSERT INTO schema_migrations (version) VALUES ('20130303015906');

INSERT INTO schema_migrations (version) VALUES ('20130304010725');

INSERT INTO schema_migrations (version) VALUES ('20130312225217');

INSERT INTO schema_migrations (version) VALUES ('20130313192517');

INSERT INTO schema_migrations (version) VALUES ('20130321002652');

INSERT INTO schema_migrations (version) VALUES ('20130321020642');

INSERT INTO schema_migrations (version) VALUES ('20130330081150');

INSERT INTO schema_migrations (version) VALUES ('20130402053427');

INSERT INTO schema_migrations (version) VALUES ('20130402071255');

INSERT INTO schema_migrations (version) VALUES ('20130404082642');

INSERT INTO schema_migrations (version) VALUES ('20130406054401');

INSERT INTO schema_migrations (version) VALUES ('20130413040339');

INSERT INTO schema_migrations (version) VALUES ('20130413043218');

INSERT INTO schema_migrations (version) VALUES ('20130417084558');

INSERT INTO schema_migrations (version) VALUES ('20130418061238');

INSERT INTO schema_migrations (version) VALUES ('20130426055604');

INSERT INTO schema_migrations (version) VALUES ('20130429202744');

INSERT INTO schema_migrations (version) VALUES ('20130501235923');

INSERT INTO schema_migrations (version) VALUES ('20130507224302');

INSERT INTO schema_migrations (version) VALUES ('20130512085953');

INSERT INTO schema_migrations (version) VALUES ('20130529042352');

INSERT INTO schema_migrations (version) VALUES ('20130530225137');

INSERT INTO schema_migrations (version) VALUES ('20130725193834');

INSERT INTO schema_migrations (version) VALUES ('20131003021323');

INSERT INTO schema_migrations (version) VALUES ('20131003045311');

INSERT INTO schema_migrations (version) VALUES ('20131009223725');