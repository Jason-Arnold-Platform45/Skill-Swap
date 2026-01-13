# SkillSwap – Backend API

SkillSwap is a **Rails API + React frontend** project that allows users to **exchange skills** by creating offers and requests and matching them together.

This repository contains the **backend API**, built with **Ruby on Rails**, **PostgreSQL**, and **JWT authentication**.

---

## ✨ Core Features

* User authentication using **JWT**
* Create skill **offers** and **requests**
* Match offers ↔ requests
* Accept / reject matches
* Soft delete skills
* Clean RESTful API design

---

## 🧠 Domain Concept

The platform is based on three core concepts:

* **Users** create skills
* **Skills** represent offers or requests
* **Matches** connect one offer with one request

> Users own skills. Skills form matches. Matches track status.

---

## 🧱 Tech Stack

* **Ruby on Rails** (API mode)
* **PostgreSQL**
* **JWT** for authentication
* **React** (frontend – separate repo)

---

## 🗄️ Database Schema

### Users

Stores authentication and identity information.

* id
* name
* email (unique)
* password_digest
* created_at / updated_at

---

### Skills

Represents a skill offer or request created by a user.

* id
* title
* description
* skill_type (`offer` or `request`)
* user_id (owner)
* deleted_at (soft delete)
* created_at / updated_at

---

### Matches

Links one offer skill with one request skill.

* id
* offer_skill_id
* request_skill_id
* status (`pending`, `accepted`, `rejected`, `cancelled`)
* created_at / updated_at

---

## 🔗 Model Relationships

* A **User** has many **Skills**
* A **Skill** belongs to one **User**
* A **Match** belongs to:

  * one offer skill
  * one request skill

Users participate in matches **through their skills**, not directly.

---

## 🔐 Authentication (JWT)

Authentication is handled using **JSON Web Tokens**.

### Auth Flow

1. User signs up or logs in
2. Server returns a JWT
3. Frontend stores the token
4. Token is sent in the `Authorization` header
5. Server identifies `current_user` from token

Protected actions require a valid JWT.

---

## 🔒 Authorization Rules

* Users can only edit or delete **their own skills**
* Users cannot match their own skills
* Matches must be **offer ↔ request** only
* Only the **offer owner** can accept or reject a match
* Soft-deleted skills cannot be matched

---

## 🔌 API Overview

### Authentication

* `POST /signup` – create account
* `POST /login` – authenticate user

### Skills

* `GET /skills` – list all skills
* `POST /skills` – create skill (auth required)
* `GET /skills/:id` – view skill
* `PUT /skills/:id` – update skill (owner only)
* `DELETE /skills/:id` – soft delete skill (owner only)

### Matches

* `POST /matches` – request a match
* `GET /matches` – view user’s matches
* `PUT /matches/:id/accept` – accept match
* `PUT /matches/:id/reject` – reject match

---

## 🚦 Match Lifecycle

1. Request created → `pending`
2. Offer owner responds:

   * Accept → `accepted`
   * Reject → `rejected`
3. Either side may cancel → `cancelled`

---

## 🧪 Development Notes

* API is designed to be consumed by a separate React frontend
* All responses are JSON
* Business rules are enforced at the application level

---

## 🌱 Future Enhancements

* User profiles
* Messaging between matched users
* Skill categories
* Notifications
* Admin moderation tools

---

## 🎯 Project Goal

This project is designed to:

* Teach **real-world Rails backend architecture**
* Demonstrate clean data modeling
* Practice JWT authentication
* Build a portfolio-ready API

---

## 🧠 Mental Model (Remember This)

> Users create skills.
> Skills connect via matches.
> Matches track the relationship.

---

## 📄 License

This project is for learning and portfolio purposes.
