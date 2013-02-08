--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: posto0; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA posto0;


SET search_path = posto0, pg_catalog;

--
-- Name: next_id(); Type: FUNCTION; Schema: posto0; Owner: -
--

CREATE FUNCTION next_id(OUT result bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
DECLARE
    our_epoch bigint := 1314220021721;
    seq_id bigint;
    now_millis bigint;
    shard_id int := 0;
BEGIN
    SELECT nextval('posto0.table_id_seq') % 1024 INTO seq_id;

    SELECT FLOOR(EXTRACT(EPOCH FROM clock_timestamp()) * 1000) INTO now_millis;
    result := (now_millis - our_epoch) << 23;
    result := result | (shard_id << 10);
    result := result | (seq_id);
END;
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: address_api_responses; Type: TABLE; Schema: posto0; Owner: -; Tablespace: 
--

CREATE TABLE address_api_responses (
    address_api_response_id bigint DEFAULT next_id() NOT NULL,
    arguments hstore NOT NULL,
    response hstore NOT NULL,
    api_type character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    meta hstore
);


--
-- Name: address_request_expirations; Type: TABLE; Schema: posto0; Owner: -; Tablespace: 
--

CREATE TABLE address_request_expirations (
    address_request_expiration_id bigint DEFAULT next_id() NOT NULL,
    address_request_id bigint NOT NULL,
    duration_hit_hours integer NOT NULL,
    duration_limit_hours integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    meta hstore
);


--
-- Name: address_request_pollings; Type: TABLE; Schema: posto0; Owner: -; Tablespace: 
--

CREATE TABLE address_request_pollings (
    address_request_polling_id bigint DEFAULT next_id() NOT NULL,
    address_request_id bigint NOT NULL,
    previous_address_request_polling_id bigint,
    poll_date timestamp without time zone NOT NULL,
    poll_index integer NOT NULL,
    latest boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    meta hstore
);


--
-- Name: address_request_states; Type: TABLE; Schema: posto0; Owner: -; Tablespace: 
--

CREATE TABLE address_request_states (
    address_request_state_id bigint DEFAULT next_id() NOT NULL,
    address_request_id bigint NOT NULL,
    state character varying(255) NOT NULL,
    latest boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    meta hstore
);


--
-- Name: address_requests; Type: TABLE; Schema: posto0; Owner: -; Tablespace: 
--

CREATE TABLE address_requests (
    address_request_id bigint DEFAULT next_id() NOT NULL,
    request_sender_user_id bigint NOT NULL,
    request_recipient_user_id bigint NOT NULL,
    app_id bigint NOT NULL,
    address_request_medium character varying(255) NOT NULL,
    address_request_payload hstore NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    meta hstore
);


--
-- Name: address_responses; Type: TABLE; Schema: posto0; Owner: -; Tablespace: 
--

CREATE TABLE address_responses (
    address_response_id bigint DEFAULT next_id() NOT NULL,
    address_request_id bigint NOT NULL,
    response_sender_user_id bigint NOT NULL,
    response_source_type character varying(255) NOT NULL,
    response_source_id character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    meta hstore,
    response_data hstore
);


--
-- Name: api_keys; Type: TABLE; Schema: posto0; Owner: -; Tablespace: 
--

CREATE TABLE api_keys (
    api_key_id bigint DEFAULT next_id() NOT NULL,
    user_id bigint NOT NULL,
    token character varying(255) NOT NULL,
    expires_at timestamp without time zone NOT NULL,
    latest boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    meta hstore
);


--
-- Name: apps; Type: TABLE; Schema: posto0; Owner: -; Tablespace: 
--

CREATE TABLE apps (
    app_id bigint DEFAULT next_id() NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    meta hstore
);


--
-- Name: card_collection_entries; Type: TABLE; Schema: posto0; Owner: -; Tablespace: 
--

CREATE TABLE card_collection_entries (
    card_collection_entry_id bigint DEFAULT next_id() NOT NULL,
    card_design_id bigint NOT NULL,
    source_type character varying(255) NOT NULL,
    source_id bigint NOT NULL,
    app_id bigint NOT NULL,
    collection_type integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    meta hstore
);


--
-- Name: card_designs; Type: TABLE; Schema: posto0; Owner: -; Tablespace: 
--

CREATE TABLE card_designs (
    card_design_id bigint DEFAULT next_id() NOT NULL,
    author_user_id bigint NOT NULL,
    source_card_design_id bigint,
    app_id bigint NOT NULL,
    design_type integer,
    top_caption character varying(255),
    bottom_caption character varying(255),
    top_caption_font_size character varying(255),
    bottom_caption_font_size character varying(255),
    original_photo_image_id integer,
    original_full_photo_image_id integer,
    edited_photo_image_id integer,
    editied_full_photo_image_id integer,
    printable_image_id integer,
    printable_full_image_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    meta hstore
);


--
-- Name: card_images; Type: TABLE; Schema: posto0; Owner: -; Tablespace: 
--

CREATE TABLE card_images (
    card_image_id bigint DEFAULT next_id() NOT NULL,
    author_user_id bigint NOT NULL,
    app_id bigint NOT NULL,
    uuid character varying(255) NOT NULL,
    width integer NOT NULL,
    height integer NOT NULL,
    orientation integer NOT NULL,
    image_type integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    meta hstore
);


--
-- Name: card_order_states; Type: TABLE; Schema: posto0; Owner: -; Tablespace: 
--

CREATE TABLE card_order_states (
    card_order_state_id bigint DEFAULT next_id() NOT NULL,
    card_order_id bigint NOT NULL,
    state character varying(255) NOT NULL,
    latest boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    meta hstore
);


--
-- Name: card_orders; Type: TABLE; Schema: posto0; Owner: -; Tablespace: 
--

CREATE TABLE card_orders (
    card_order_id bigint DEFAULT next_id() NOT NULL,
    order_sender_user_id bigint NOT NULL,
    app_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    meta hstore
);


--
-- Name: card_printing_print_number_seq; Type: SEQUENCE; Schema: posto0; Owner: -
--

CREATE SEQUENCE card_printing_print_number_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: card_printing_states; Type: TABLE; Schema: posto0; Owner: -; Tablespace: 
--

CREATE TABLE card_printing_states (
    card_printing_state_id bigint DEFAULT next_id() NOT NULL,
    card_printing_id bigint NOT NULL,
    state character varying(255) NOT NULL,
    latest boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    meta hstore
);


--
-- Name: card_printings; Type: TABLE; Schema: posto0; Owner: -; Tablespace: 
--

CREATE TABLE card_printings (
    card_printing_id bigint DEFAULT next_id() NOT NULL,
    card_order_id bigint NOT NULL,
    recipient_user_id bigint NOT NULL,
    printed_image_id bigint NOT NULL,
    print_number bigint DEFAULT nextval('card_printing_print_number_seq'::regclass) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    meta hstore
);


--
-- Name: card_scan_authors; Type: TABLE; Schema: posto0; Owner: -; Tablespace: 
--

CREATE TABLE card_scan_authors (
    card_scan_author_id bigint DEFAULT next_id() NOT NULL,
    card_scan_id bigint NOT NULL,
    author_user_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    meta hstore
);


--
-- Name: card_scans; Type: TABLE; Schema: posto0; Owner: -; Tablespace: 
--

CREATE TABLE card_scans (
    card_scan_id bigint DEFAULT next_id() NOT NULL,
    card_printing_id bigint NOT NULL,
    app_id bigint NOT NULL,
    scanned_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    meta hstore
);


--
-- Name: facebook_token_states; Type: TABLE; Schema: posto0; Owner: -; Tablespace: 
--

CREATE TABLE facebook_token_states (
    facebook_token_state_id bigint DEFAULT next_id() NOT NULL,
    facebook_token_id bigint NOT NULL,
    state character varying(255) NOT NULL,
    latest boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    meta hstore
);


--
-- Name: facebook_tokens; Type: TABLE; Schema: posto0; Owner: -; Tablespace: 
--

CREATE TABLE facebook_tokens (
    facebook_token_id bigint DEFAULT next_id() NOT NULL,
    user_id bigint NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    meta hstore
);


--
-- Name: recipient_addresses; Type: TABLE; Schema: posto0; Owner: -; Tablespace: 
--

CREATE TABLE recipient_addresses (
    recipient_address_id bigint DEFAULT next_id() NOT NULL,
    recipient_user_id bigint NOT NULL,
    address_api_response_id bigint NOT NULL,
    latest boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    meta hstore,
    address_request_id bigint NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: posto0; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: stripe_cards; Type: TABLE; Schema: posto0; Owner: -; Tablespace: 
--

CREATE TABLE stripe_cards (
    stripe_card_id bigint DEFAULT next_id() NOT NULL,
    exp_month integer NOT NULL,
    exp_year integer NOT NULL,
    fingerprint character varying(255) NOT NULL,
    last4 character varying(255) NOT NULL,
    card_type character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    meta hstore
);


--
-- Name: stripe_customer_card_states; Type: TABLE; Schema: posto0; Owner: -; Tablespace: 
--

CREATE TABLE stripe_customer_card_states (
    stripe_customer_card_state_id bigint DEFAULT next_id() NOT NULL,
    stripe_customer_card_id bigint NOT NULL,
    state character varying(255) NOT NULL,
    latest boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    meta hstore
);


--
-- Name: stripe_customer_cards; Type: TABLE; Schema: posto0; Owner: -; Tablespace: 
--

CREATE TABLE stripe_customer_cards (
    stripe_customer_card_id bigint DEFAULT next_id() NOT NULL,
    stripe_customer_id bigint NOT NULL,
    stripe_card_id bigint NOT NULL,
    latest boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    meta hstore
);


--
-- Name: stripe_customers; Type: TABLE; Schema: posto0; Owner: -; Tablespace: 
--

CREATE TABLE stripe_customers (
    stripe_customer_id bigint DEFAULT next_id() NOT NULL,
    user_id bigint NOT NULL,
    latest boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    meta hstore,
    stripe_id character varying(255) NOT NULL
);


--
-- Name: table_id_seq; Type: SEQUENCE; Schema: posto0; Owner: -
--

CREATE SEQUENCE table_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transaction_line_items; Type: TABLE; Schema: posto0; Owner: -; Tablespace: 
--

CREATE TABLE transaction_line_items (
    transaction_line_item_id bigint DEFAULT next_id() NOT NULL,
    transaction_id bigint NOT NULL,
    description character varying(255) NOT NULL,
    price_units integer NOT NULL,
    currency character varying(255) NOT NULL,
    is_credit boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    meta hstore
);


--
-- Name: transactions; Type: TABLE; Schema: posto0; Owner: -; Tablespace: 
--

CREATE TABLE transactions (
    transaction_id bigint DEFAULT next_id() NOT NULL,
    card_order_id bigint NOT NULL,
    charged_customer_type character varying(255) NOT NULL,
    charged_customer_id bigint NOT NULL,
    response hstore NOT NULL,
    status character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    meta hstore
);


--
-- Name: user_logins; Type: TABLE; Schema: posto0; Owner: -; Tablespace: 
--

CREATE TABLE user_logins (
    user_login_id bigint DEFAULT next_id() NOT NULL,
    user_id bigint NOT NULL,
    app_id bigint NOT NULL,
    latest boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    meta hstore
);


--
-- Name: user_profiles; Type: TABLE; Schema: posto0; Owner: -; Tablespace: 
--

CREATE TABLE user_profiles (
    user_profile_id bigint DEFAULT next_id() NOT NULL,
    user_id bigint NOT NULL,
    name character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    location character varying(255),
    middle_name character varying(255),
    birthday timestamp without time zone,
    gender character varying(255),
    email character varying(255),
    latest boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    meta hstore
);


--
-- Name: users; Type: TABLE; Schema: posto0; Owner: -; Tablespace: 
--

CREATE TABLE users (
    user_id bigint DEFAULT next_id() NOT NULL,
    facebook_id character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    meta hstore
);


--
-- Name: address_api_responses_pkey; Type: CONSTRAINT; Schema: posto0; Owner: -; Tablespace: 
--

ALTER TABLE ONLY address_api_responses
    ADD CONSTRAINT address_api_responses_pkey PRIMARY KEY (address_api_response_id);


--
-- Name: address_request_expirations_pkey; Type: CONSTRAINT; Schema: posto0; Owner: -; Tablespace: 
--

ALTER TABLE ONLY address_request_expirations
    ADD CONSTRAINT address_request_expirations_pkey PRIMARY KEY (address_request_expiration_id);


--
-- Name: address_request_pollings_pkey; Type: CONSTRAINT; Schema: posto0; Owner: -; Tablespace: 
--

ALTER TABLE ONLY address_request_pollings
    ADD CONSTRAINT address_request_pollings_pkey PRIMARY KEY (address_request_polling_id);


--
-- Name: address_request_states_pkey; Type: CONSTRAINT; Schema: posto0; Owner: -; Tablespace: 
--

ALTER TABLE ONLY address_request_states
    ADD CONSTRAINT address_request_states_pkey PRIMARY KEY (address_request_state_id);


--
-- Name: address_requests_pkey; Type: CONSTRAINT; Schema: posto0; Owner: -; Tablespace: 
--

ALTER TABLE ONLY address_requests
    ADD CONSTRAINT address_requests_pkey PRIMARY KEY (address_request_id);


--
-- Name: address_responses_pkey; Type: CONSTRAINT; Schema: posto0; Owner: -; Tablespace: 
--

ALTER TABLE ONLY address_responses
    ADD CONSTRAINT address_responses_pkey PRIMARY KEY (address_response_id);


--
-- Name: api_keys_pkey; Type: CONSTRAINT; Schema: posto0; Owner: -; Tablespace: 
--

ALTER TABLE ONLY api_keys
    ADD CONSTRAINT api_keys_pkey PRIMARY KEY (api_key_id);


--
-- Name: apps_pkey; Type: CONSTRAINT; Schema: posto0; Owner: -; Tablespace: 
--

ALTER TABLE ONLY apps
    ADD CONSTRAINT apps_pkey PRIMARY KEY (app_id);


--
-- Name: card_collection_entries_pkey; Type: CONSTRAINT; Schema: posto0; Owner: -; Tablespace: 
--

ALTER TABLE ONLY card_collection_entries
    ADD CONSTRAINT card_collection_entries_pkey PRIMARY KEY (card_collection_entry_id);


--
-- Name: card_designs_pkey; Type: CONSTRAINT; Schema: posto0; Owner: -; Tablespace: 
--

ALTER TABLE ONLY card_designs
    ADD CONSTRAINT card_designs_pkey PRIMARY KEY (card_design_id);


--
-- Name: card_images_pkey; Type: CONSTRAINT; Schema: posto0; Owner: -; Tablespace: 
--

ALTER TABLE ONLY card_images
    ADD CONSTRAINT card_images_pkey PRIMARY KEY (card_image_id);


--
-- Name: card_order_states_pkey; Type: CONSTRAINT; Schema: posto0; Owner: -; Tablespace: 
--

ALTER TABLE ONLY card_order_states
    ADD CONSTRAINT card_order_states_pkey PRIMARY KEY (card_order_state_id);


--
-- Name: card_orders_pkey; Type: CONSTRAINT; Schema: posto0; Owner: -; Tablespace: 
--

ALTER TABLE ONLY card_orders
    ADD CONSTRAINT card_orders_pkey PRIMARY KEY (card_order_id);


--
-- Name: card_printing_states_pkey; Type: CONSTRAINT; Schema: posto0; Owner: -; Tablespace: 
--

ALTER TABLE ONLY card_printing_states
    ADD CONSTRAINT card_printing_states_pkey PRIMARY KEY (card_printing_state_id);


--
-- Name: card_printings_pkey; Type: CONSTRAINT; Schema: posto0; Owner: -; Tablespace: 
--

ALTER TABLE ONLY card_printings
    ADD CONSTRAINT card_printings_pkey PRIMARY KEY (card_printing_id);


--
-- Name: card_scan_authors_pkey; Type: CONSTRAINT; Schema: posto0; Owner: -; Tablespace: 
--

ALTER TABLE ONLY card_scan_authors
    ADD CONSTRAINT card_scan_authors_pkey PRIMARY KEY (card_scan_author_id);


--
-- Name: card_scans_pkey; Type: CONSTRAINT; Schema: posto0; Owner: -; Tablespace: 
--

ALTER TABLE ONLY card_scans
    ADD CONSTRAINT card_scans_pkey PRIMARY KEY (card_scan_id);


--
-- Name: facebook_token_states_pkey; Type: CONSTRAINT; Schema: posto0; Owner: -; Tablespace: 
--

ALTER TABLE ONLY facebook_token_states
    ADD CONSTRAINT facebook_token_states_pkey PRIMARY KEY (facebook_token_state_id);


--
-- Name: facebook_tokens_pkey; Type: CONSTRAINT; Schema: posto0; Owner: -; Tablespace: 
--

ALTER TABLE ONLY facebook_tokens
    ADD CONSTRAINT facebook_tokens_pkey PRIMARY KEY (facebook_token_id);


--
-- Name: recipient_addresses_pkey; Type: CONSTRAINT; Schema: posto0; Owner: -; Tablespace: 
--

ALTER TABLE ONLY recipient_addresses
    ADD CONSTRAINT recipient_addresses_pkey PRIMARY KEY (recipient_address_id);


--
-- Name: stripe_cards_pkey; Type: CONSTRAINT; Schema: posto0; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stripe_cards
    ADD CONSTRAINT stripe_cards_pkey PRIMARY KEY (stripe_card_id);


--
-- Name: stripe_customer_card_states_pkey; Type: CONSTRAINT; Schema: posto0; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stripe_customer_card_states
    ADD CONSTRAINT stripe_customer_card_states_pkey PRIMARY KEY (stripe_customer_card_state_id);


--
-- Name: stripe_customer_cards_pkey; Type: CONSTRAINT; Schema: posto0; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stripe_customer_cards
    ADD CONSTRAINT stripe_customer_cards_pkey PRIMARY KEY (stripe_customer_card_id);


--
-- Name: stripe_customers_pkey; Type: CONSTRAINT; Schema: posto0; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stripe_customers
    ADD CONSTRAINT stripe_customers_pkey PRIMARY KEY (stripe_customer_id);


--
-- Name: transaction_line_items_pkey; Type: CONSTRAINT; Schema: posto0; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transaction_line_items
    ADD CONSTRAINT transaction_line_items_pkey PRIMARY KEY (transaction_line_item_id);


--
-- Name: transactions_pkey; Type: CONSTRAINT; Schema: posto0; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (transaction_id);


--
-- Name: user_logins_pkey; Type: CONSTRAINT; Schema: posto0; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_logins
    ADD CONSTRAINT user_logins_pkey PRIMARY KEY (user_login_id);


--
-- Name: user_profiles_pkey; Type: CONSTRAINT; Schema: posto0; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_profiles
    ADD CONSTRAINT user_profiles_pkey PRIMARY KEY (user_profile_id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: posto0; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: address_req_polling_previous_idx; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX address_req_polling_previous_idx ON address_request_pollings USING btree (previous_address_request_polling_id);


--
-- Name: address_request_states_state_latest_idx; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX address_request_states_state_latest_idx ON address_request_states USING btree (state, latest) WHERE (latest = true);


--
-- Name: address_response_source_idx; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX address_response_source_idx ON address_responses USING btree (response_source_type, response_source_id);


--
-- Name: api_key_states_user_id_latest_idx; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX api_key_states_user_id_latest_idx ON api_keys USING btree (user_id, latest) WHERE (latest = true);


--
-- Name: arguments_idx; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX arguments_idx ON address_api_responses USING gin (arguments);


--
-- Name: card_collection_entry_unique_idx; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX card_collection_entry_unique_idx ON card_collection_entries USING btree (card_design_id, app_id, collection_type);


--
-- Name: card_order_states_state_latest_idx; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX card_order_states_state_latest_idx ON card_order_states USING btree (state, latest) WHERE (latest = true);


--
-- Name: card_printing_states_state_latest_idx; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX card_printing_states_state_latest_idx ON card_printing_states USING btree (state, latest) WHERE (latest = true);


--
-- Name: facebook_token_states_state_latest_idx; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX facebook_token_states_state_latest_idx ON facebook_token_states USING btree (state, latest) WHERE (latest = true);


--
-- Name: index_address_request_expirations_on_address_request_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_address_request_expirations_on_address_request_id ON address_request_expirations USING btree (address_request_id);


--
-- Name: index_address_request_pollings_on_address_request_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_address_request_pollings_on_address_request_id ON address_request_pollings USING btree (address_request_id);


--
-- Name: index_address_request_pollings_on_latest; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_address_request_pollings_on_latest ON address_request_pollings USING btree (latest);


--
-- Name: index_address_request_states_on_address_request_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_address_request_states_on_address_request_id ON address_request_states USING btree (address_request_id);


--
-- Name: index_address_request_states_on_latest; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_address_request_states_on_latest ON address_request_states USING btree (latest);


--
-- Name: index_address_requests_on_recipient_user_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_address_requests_on_recipient_user_id ON address_requests USING btree (request_recipient_user_id);


--
-- Name: index_address_requests_on_sender_user_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_address_requests_on_sender_user_id ON address_requests USING btree (request_sender_user_id);


--
-- Name: index_address_responses_on_address_request_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_address_responses_on_address_request_id ON address_responses USING btree (address_request_id);


--
-- Name: index_address_responses_on_response_sender_user_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_address_responses_on_response_sender_user_id ON address_responses USING btree (response_sender_user_id);


--
-- Name: index_api_keys_on_latest; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_api_keys_on_latest ON api_keys USING btree (latest);


--
-- Name: index_api_keys_on_token; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_api_keys_on_token ON api_keys USING btree (token);


--
-- Name: index_api_keys_on_user_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_api_keys_on_user_id ON api_keys USING btree (user_id);


--
-- Name: index_card_collection_entries_on_card_design_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_card_collection_entries_on_card_design_id ON card_collection_entries USING btree (card_design_id);


--
-- Name: index_card_collection_entries_on_source_type_and_source_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_card_collection_entries_on_source_type_and_source_id ON card_collection_entries USING btree (source_type, source_id);


--
-- Name: index_card_designs_on_author_user_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_card_designs_on_author_user_id ON card_designs USING btree (author_user_id);


--
-- Name: index_card_designs_on_edited_photo_image_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_card_designs_on_edited_photo_image_id ON card_designs USING btree (edited_photo_image_id);


--
-- Name: index_card_designs_on_editied_full_photo_image_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_card_designs_on_editied_full_photo_image_id ON card_designs USING btree (editied_full_photo_image_id);


--
-- Name: index_card_designs_on_original_full_photo_image_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_card_designs_on_original_full_photo_image_id ON card_designs USING btree (original_full_photo_image_id);


--
-- Name: index_card_designs_on_original_photo_image_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_card_designs_on_original_photo_image_id ON card_designs USING btree (original_photo_image_id);


--
-- Name: index_card_designs_on_printable_full_image_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_card_designs_on_printable_full_image_id ON card_designs USING btree (printable_full_image_id);


--
-- Name: index_card_designs_on_printable_image_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_card_designs_on_printable_image_id ON card_designs USING btree (printable_image_id);


--
-- Name: index_card_designs_on_source_card_design_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_card_designs_on_source_card_design_id ON card_designs USING btree (source_card_design_id);


--
-- Name: index_card_images_on_author_user_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_card_images_on_author_user_id ON card_images USING btree (author_user_id);


--
-- Name: index_card_images_on_uuid; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_card_images_on_uuid ON card_images USING btree (uuid);


--
-- Name: index_card_order_states_on_card_order_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_card_order_states_on_card_order_id ON card_order_states USING btree (card_order_id);


--
-- Name: index_card_order_states_on_latest; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_card_order_states_on_latest ON card_order_states USING btree (latest);


--
-- Name: index_card_orders_on_sender_user_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_card_orders_on_sender_user_id ON card_orders USING btree (order_sender_user_id);


--
-- Name: index_card_printing_states_on_card_printing_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_card_printing_states_on_card_printing_id ON card_printing_states USING btree (card_printing_id);


--
-- Name: index_card_printing_states_on_latest; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_card_printing_states_on_latest ON card_printing_states USING btree (latest);


--
-- Name: index_card_printings_on_card_order_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_card_printings_on_card_order_id ON card_printings USING btree (card_order_id);


--
-- Name: index_card_printings_on_print_number; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_card_printings_on_print_number ON card_printings USING btree (print_number);


--
-- Name: index_card_printings_on_printed_image_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_card_printings_on_printed_image_id ON card_printings USING btree (printed_image_id);


--
-- Name: index_card_printings_on_recipient_user_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_card_printings_on_recipient_user_id ON card_printings USING btree (recipient_user_id);


--
-- Name: index_card_scan_authors_on_author_user_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_card_scan_authors_on_author_user_id ON card_scan_authors USING btree (author_user_id);


--
-- Name: index_card_scan_authors_on_card_scan_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_card_scan_authors_on_card_scan_id ON card_scan_authors USING btree (card_scan_id);


--
-- Name: index_card_scans_on_card_printing_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_card_scans_on_card_printing_id ON card_scans USING btree (card_printing_id);


--
-- Name: index_card_scans_on_scanned_at; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_card_scans_on_scanned_at ON card_scans USING btree (scanned_at);


--
-- Name: index_facebook_token_states_on_facebook_token_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_facebook_token_states_on_facebook_token_id ON facebook_token_states USING btree (facebook_token_id);


--
-- Name: index_facebook_token_states_on_latest; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_facebook_token_states_on_latest ON facebook_token_states USING btree (latest);


--
-- Name: index_facebook_tokens_on_token; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_facebook_tokens_on_token ON facebook_tokens USING btree (token);


--
-- Name: index_facebook_tokens_on_user_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_facebook_tokens_on_user_id ON facebook_tokens USING btree (user_id);


--
-- Name: index_recipient_addresses_on_address_api_response_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_recipient_addresses_on_address_api_response_id ON recipient_addresses USING btree (address_api_response_id);


--
-- Name: index_recipient_addresses_on_address_request_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_recipient_addresses_on_address_request_id ON recipient_addresses USING btree (address_request_id);


--
-- Name: index_recipient_addresses_on_latest; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_recipient_addresses_on_latest ON recipient_addresses USING btree (latest);


--
-- Name: index_recipient_addresses_on_recipient_user_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_recipient_addresses_on_recipient_user_id ON recipient_addresses USING btree (recipient_user_id);


--
-- Name: index_stripe_cards_on_fingerprint; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_stripe_cards_on_fingerprint ON stripe_cards USING btree (fingerprint);


--
-- Name: index_stripe_customer_card_states_on_stripe_customer_card_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_stripe_customer_card_states_on_stripe_customer_card_id ON stripe_customer_card_states USING btree (stripe_customer_card_id);


--
-- Name: index_stripe_customer_cards_on_stripe_card_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_stripe_customer_cards_on_stripe_card_id ON stripe_customer_cards USING btree (stripe_card_id);


--
-- Name: index_stripe_customer_cards_on_stripe_customer_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_stripe_customer_cards_on_stripe_customer_id ON stripe_customer_cards USING btree (stripe_customer_id);


--
-- Name: index_stripe_customers_on_latest; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_stripe_customers_on_latest ON stripe_customers USING btree (latest);


--
-- Name: index_stripe_customers_on_stripe_customer_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_stripe_customers_on_stripe_customer_id ON stripe_customers USING btree (stripe_customer_id);


--
-- Name: index_stripe_customers_on_stripe_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_stripe_customers_on_stripe_id ON stripe_customers USING btree (stripe_id);


--
-- Name: index_stripe_customers_on_user_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_stripe_customers_on_user_id ON stripe_customers USING btree (user_id);


--
-- Name: index_transaction_line_items_on_transaction_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_transaction_line_items_on_transaction_id ON transaction_line_items USING btree (transaction_id);


--
-- Name: index_transactions_on_card_order_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_transactions_on_card_order_id ON transactions USING btree (card_order_id);


--
-- Name: index_user_logins_on_user_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_user_logins_on_user_id ON user_logins USING btree (user_id);


--
-- Name: index_user_profiles_on_email; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_user_profiles_on_email ON user_profiles USING btree (email);


--
-- Name: index_user_profiles_on_last_name; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_user_profiles_on_last_name ON user_profiles USING btree (last_name);


--
-- Name: index_user_profiles_on_latest; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_user_profiles_on_latest ON user_profiles USING btree (latest);


--
-- Name: index_user_profiles_on_name; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_user_profiles_on_name ON user_profiles USING btree (name);


--
-- Name: index_user_profiles_on_user_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX index_user_profiles_on_user_id ON user_profiles USING btree (user_id);


--
-- Name: index_users_on_facebook_id; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_facebook_id ON users USING btree (facebook_id);


--
-- Name: response_idx; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX response_idx ON address_api_responses USING gin (response);


--
-- Name: transaction_customer_idx; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX transaction_customer_idx ON transactions USING btree (charged_customer_type, charged_customer_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: user_login_user_id_latest_idx; Type: INDEX; Schema: posto0; Owner: -; Tablespace: 
--

CREATE INDEX user_login_user_id_latest_idx ON user_logins USING btree (user_id, latest) WHERE (latest = true);


--
-- PostgreSQL database dump complete
--

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