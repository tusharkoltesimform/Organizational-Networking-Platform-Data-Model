
CREATE TABLE IF NOT EXISTS "user" (
	"user-id" serial NOT NULL UNIQUE,
	"username" varchar2(225) NOT NULL UNIQUE,
	"email" varchar2(225) NOT NULL UNIQUE,
	"password" varchar2(225) NOT NULL,
	"profile_photo" blob,
	"created_at" TIMESTAMPTZ NOT NULL,
	"updated_at" TIMESTAMPTZ NOT NULL,
	PRIMARY KEY("user-id")
);


CREATE TABLE IF NOT EXISTS "orgnaization" (
	"org_id" serial NOT NULL UNIQUE,
	"org_name" varchar2(225) NOT NULL,
	"created_at" TIMESTAMPTZ NOT NULL,
	"updated_at" TIMESTAMPTZ NOT NULL,
	PRIMARY KEY("org_id")
);

CREATE INDEX "table2_index_0"
ON "orgnaization" ("iduser");
CREATE TYPE "membership_type_t" AS ENUM ('Full time', 'Part time', 'follower');

CREATE TYPE "status_t" AS ENUM ('Requested', 'Accepted', 'Rejected');

CREATE TABLE IF NOT EXISTS "user_org_membership" (
	"membership_id" serial NOT NULL UNIQUE,
	"user_id" int NOT NULL,
	"org_id" int NOT NULL,
	-- Full Time, Part Time, Followers
	"membership_type" membership_type_t NOT NULL,
	-- Requested, Accepted, Rejected
	"status" status_t NOT NULL,
	"created_at" TIMESTAMPTZ NOT NULL,
	"updated_at" TIMESTAMPTZ NOT NULL,
	PRIMARY KEY("membership_id")
);
COMMENT ON COLUMN user_org_membership.membership_type IS 'Full Time, Part Time, Followers';
COMMENT ON COLUMN user_org_membership.status IS 'Requested, Accepted, Rejected';


CREATE TABLE IF NOT EXISTS "user_user_connection" (
	"connection_id" serial NOT NULL UNIQUE,
	"leader_id" int NOT NULL,
	"follower_id" int NOT NULL,
	"status" varchar2(225) NOT NULL,
	"followed_at" TIMESTAMPTZ NOT NULL,
	PRIMARY KEY("connection_id")
);


CREATE TABLE IF NOT EXISTS "position" (
	"position_id" serial NOT NULL UNIQUE,
	"org_id" int NOT NULL,
	"title" varchar2(225) NOT NULL,
	"user_id" int,
	"is_founder" boolean NOT NULL,
	"created_at" TIMESTAMPTZ NOT NULL,
	"updated_at" TIMESTAMPTZ NOT NULL,
	"parent_id" int,
	PRIMARY KEY("position_id")
);


CREATE TABLE IF NOT EXISTS "password_reset" (
	"token_id" serial NOT NULL UNIQUE,
	"user_id" int NOT NULL,
	"token" text(65535) NOT NULL,
	"expires_on" timestamp NOT NULL,
	"created_at" TIMESTAMPTZ NOT NULL,
	PRIMARY KEY("token_id")
);


CREATE TABLE IF NOT EXISTS "position_history" (
	"history_id" int NOT NULL,
	"position_id" serial NOT NULL UNIQUE,
	"user_id" int NOT NULL,
	"assigned_from" TIMESTAMPTZ NOT NULL,
	PRIMARY KEY("history_id")
);


ALTER TABLE "user"
ADD FOREIGN KEY("user-id") REFERENCES "user_org_membership"("user_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "orgnaization"
ADD FOREIGN KEY("org_id") REFERENCES "user_org_membership"("org_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "user"
ADD FOREIGN KEY("user-id") REFERENCES "user_user_connection"("leader_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "user"
ADD FOREIGN KEY("user-id") REFERENCES "user_user_connection"("follower_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "user"
ADD FOREIGN KEY("user-id") REFERENCES "password_reset"("user_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "orgnaization"
ADD FOREIGN KEY("org_id") REFERENCES "position"("org_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "user"
ADD FOREIGN KEY("user-id") REFERENCES "position"("user_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "position"
ADD FOREIGN KEY("position_id") REFERENCES "position"("parent_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "position_history"
ADD FOREIGN KEY("position_id") REFERENCES "position"("position_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "user"
ADD FOREIGN KEY("user-id") REFERENCES "position_history"("user_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;