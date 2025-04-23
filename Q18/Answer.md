# Ans 18.2

### 1. **Artist “creates” ArtObject (1 : N)**

- **Mapping:** Add `artist_id` as a foreign key in **ArtObject** referencing **Artist(artist_id)**.
- **Why:** In a 1 : N relationship, the “many” side stores the primary key of the “one” side.
- **Constraint enforced:**
  - `ArtObject.artist_id NOT NULL` (mandatory participation)
  - `FOREIGN KEY (artist_id) REFERENCES Artist(artist_id) ON DELETE RESTRICT`

---

### 2. **Artist → Styles (multivalued attribute)**

- **Mapping:** Create table **Artist_Styles(artist_id, style)** with composite PK `(artist_id, style)` and FK to **Artist**.
- **Why:** Multivalued attributes must become separate tables to avoid repeating columns.
- **Constraint enforced:**
  - `PRIMARY KEY (artist_id, style)` prevents duplicates
  - `FOREIGN KEY (artist_id) REFERENCES Artist(artist_id) ON DELETE CASCADE`

---

### 3. **ArtObject — Borrowed_from → Owner (via weak entity Period)**

- **Mapping:**
  1. `Period(object_id, start_date, end_date, owner_id)` where
     - `object_id` PK & FK → **ArtObject(object_id)**
     - `owner_id` FK → **Owner(owner_id)**
- **Why:**
  - **Period** is weak—its identity depends on a specific `ArtObject`.
  - We model the identifying relationship by making `object_id` both PK and FK.
- **Constraint enforced:**
  - `PRIMARY KEY (object_id)`
  - `FOREIGN KEY (object_id) REFERENCES ArtObject(object_id) ON DELETE CASCADE`
  - `FOREIGN KEY (owner_id) REFERENCES Owner(owner_id) ON DELETE RESTRICT`

---

### 4. **ArtObject → Temporary / Permanent (disjoint, total specializations)**

- **Mapping:** Four tables—**Temporary**, **Permanent**, **Painting**, **Sculpture**—each with
  - `object_id` PK & FK → **ArtObject(object_id)**
  - Subclass‐specific columns
- **Why:** Disjoint subclasses require “table-per-subclass”: each `ArtObject` row appears in exactly one subclass table.
- **Constraint enforced:**
  - `PRIMARY KEY (object_id)`
  - `FOREIGN KEY (object_id) REFERENCES ArtObject(object_id) ON DELETE CASCADE`

---

### 5. **Sculpture → Statue (disjoint, total sub‐subclass)**

- **Mapping:** **Statue(object_id)** with PK & FK → **Sculpture(object_id)**.
- **Why:** Further specialization of a subclass follows the same table‐per‐subclass pattern.
- **Constraint enforced:**
  - `PRIMARY KEY (object_id)`
  - `FOREIGN KEY (object_id) REFERENCES Sculpture(object_id) ON DELETE CASCADE`

---

### 6. **Event → Exhibition & Auction (overlapping, partial specializations)**

- **Mapping:** Two tables—**Exhibition(event_id, …)** and **Auction(event_id, …)**—each with
  - `event_id` PK & FK → **Event(event_id)**
- **Why:** Overlapping subclasses allow an `Event` row to appear in one, both, or neither subtype table.
- **Constraint enforced:**
  - `PRIMARY KEY (event_id)`
  - `FOREIGN KEY (event_id) REFERENCES Event(event_id) ON DELETE CASCADE`

---

### 7. **Exhibition → Sponsors (multivalued)**

- **Mapping:** **Sponsors(event_id, sponsor)** with composite PK `(event_id, sponsor)` and FK → **Exhibition**.
- **Why:** Multivalued attribute on a subclass follows same pattern as for strong entities.
- **Constraint enforced:**
  - `PRIMARY KEY (event_id, sponsor)`
  - `FOREIGN KEY (event_id) REFERENCES Exhibition(event_id) ON DELETE CASCADE`

---

### 8. **ArtObject ↔ Event “Shown_at” (M : N)**

- **Mapping:** **ShownAt(object_id, event_id)** with composite PK `(object_id, event_id)` and FKs to both tables.
- **Why:** Many-to-many relationships require a join table.
- **Constraint enforced:**
  - `PRIMARY KEY (object_id, event_id)`
  - `FOREIGN KEY (object_id) REFERENCES ArtObject(object_id) ON DELETE CASCADE`
  - `FOREIGN KEY (event_id)  REFERENCES Event(event_id)     ON DELETE CASCADE`

# Ans 18.3

| Foreign Key                 | Not Null? | Unique? | Justification                                                                                                                                                                      |
| --------------------------- | --------- | ------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Artist_Styles.artist_id** | No        | No      | An artist may have zero or many styles (partial participation), and styles repeat per artist.                                                                                      |
| **ArtObject.artist_id**     | Yes       | No      | 1 :N Creates – every art object **must** have an artist (total), but an artist can create many objects.                                                                            |
| **Period.object_id**        | Yes       | Yes     | Weak-entity Period → ArtObject is 1 : 1 (identifying); object_id is both PK and FK, hence unique.                                                                                  |
| **Period.owner_id**         | Yes       | No      | Borrowed_from (Period→Owner) is 1 : 1 total on Owner side but 1 : N on Period side; each Period must link to one Owner (NOT NULL), but an Owner can have many Periods (no UNIQUE). |
| **Temporary.object_id**     | Yes       | Yes     | Disjoint specialization Temporary ⊆ ArtObject is 1 : 1 total; object_id is PK=FK, so unique.                                                                                       |
| **Permanent.object_id**     | Yes       | Yes     | Disjoint specialization Permanent ⊆ ArtObject is 1 : 1 total; object_id is PK=FK, so unique.                                                                                       |
| **Painting.object_id**      | Yes       | Yes     | Disjoint subtype Painting ⊆ ArtObject is 1 : 1 total; object_id is PK=FK, so unique.                                                                                               |
| **Sculpture.object_id**     | Yes       | Yes     | Disjoint subtype Sculpture ⊆ ArtObject is 1 : 1 total; object_id is PK=FK, so unique.                                                                                              |
| **Statue.object_id**        | Yes       | Yes     | Further subtype Statue ⊆ Sculpture is 1 : 1 total; object_id is PK=FK, so unique.                                                                                                  |
| **Exhibition.event_id**     | Yes       | Yes     | Overlapping subtype Exhibition ⊆ Event is 1 : 1 (per row) when present; event_id is PK=FK, unique.                                                                                 |
| **Sponsors.event_id**       | Yes       | No      | Multivalued attribute Sponsors on Exhibition; each Expo must have ≥0 sponsors (NOT NULL), and can have many (no UNIQUE).                                                           |
| **Auction.event_id**        | Yes       | Yes     | Overlapping subtype Auction ⊆ Event is 1 : 1 (per row) when present; event_id is PK=FK, unique.                                                                                    |
| **ShownAt.object_id**       | Yes       | No      | M : N relationship – each ShownAt row must reference an ArtObject (NOT NULL), and an object may appear in many events (no UNIQUE).                                                 |
| **ShownAt.event_id**        | Yes       | No      | M : N relationship – each ShownAt row must reference an Event (NOT NULL), and an event may host many objects (no UNIQUE).                                                          |
