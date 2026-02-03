erDiagram
	user ||--o{ user_org_membership : references
	orgnaization ||--o{ user_org_membership : references
	user ||--o{ user_user_connection : references
	user ||--o{ user_user_connection : references
	user ||--o{ password_reset : references
	orgnaization ||--o{ position : references
	user ||--o{ position : references
	position ||--o{ position : references
	position_history ||--|| position : references
	user ||--o{ position_history : references

	user {
		INT user-id
		VARCHAR2(225) username
		VARCHAR2(225) email
		VARCHAR2(225) password
		BLOB profile_photo
		TIMESTAMP created_at
		TIMESTAMP updated_at
	}

	orgnaization {
		INT org_id
		VARCHAR2(225) org_name
		TIMESTAMP created_at
		TIMESTAMP updated_at
	}

	user_org_membership {
		INT membership_id
		INT user_id
		INT org_id
		ENUM membership_type
		ENUM status
		TIMESTAMP created_at
		TIMESTAMP updated_at
	}

	user_user_connection {
		INT connection_id
		INT leader_id
		INT follower_id
		VARCHAR2(225) status
		TIMESTAMP followed_at
	}

	position {
		INT position_id
		INT org_id
		VARCHAR2(225) title
		INT user_id
		BOOLEAN is_founder
		TIMESTAMP created_at
		TIMESTAMP updated_at
		INT parent_id
	}

	password_reset {
		INT token_id
		INT user_id
		TEXT(65535) token
		DATETIME expires_on
		TIMESTAMP created_at
	}

	position_history {
		INT history_id
		INT position_id
		INT user_id
		TIMESTAMP assigned_from
	}