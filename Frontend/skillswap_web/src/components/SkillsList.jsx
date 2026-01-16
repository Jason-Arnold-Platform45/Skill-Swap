import React, { useEffect, useState } from "react";
import { fetchSkills } from "../services/skillsApi";
import LoadingState from "./LoadingState";
import ErrorState from "./ErrorState";

const API_URL = import.meta.env.VITE_API_BASE_URL;
const TOKEN_KEY = "authToken";

export default function SkillsList() {
  const [skills, setSkills] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [selectedSkill, setSelectedSkill] = useState(null);

  const [showCreateModal, setShowCreateModal] = useState(false);
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [skillType, setSkillType] = useState("offer");

  const loadSkills = async () => {
    try {
      setLoading(true);
      const data = await fetchSkills();
      setSkills(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadSkills();
  }, []);

  const handleRequestMatch = async (skillId) => {
    try {
      const token = localStorage.getItem(TOKEN_KEY);
      if (!token) {
        alert("You must be logged in");
        return;
      }

      const response = await fetch(`${API_URL}/matches`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify({
          match: { skill_id: skillId },
        }),
      });

      if (!response.ok) throw new Error("Request failed");

      alert("Match request sent!");
      setSelectedSkill(null);
    } catch (err) {
      alert(err.message);
    }
  };

  const handleCreateSkill = async (e) => {
    e.preventDefault();

    try {
      const token = localStorage.getItem(TOKEN_KEY);
      if (!token) {
        alert("You must be logged in");
        return;
      }

      const response = await fetch(`${API_URL}/skills`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify({
          skill: {
            title,
            description,
            skill_type: skillType,
          },
        }),
      });

      if (!response.ok) throw new Error("Failed to create skill");

      setShowCreateModal(false);
      setTitle("");
      setDescription("");
      setSkillType("offer");
      loadSkills();
    } catch (err) {
      alert(err.message);
    }
  };

  if (loading) return <LoadingState />;
  if (error) return <ErrorState error={error} />;

  return (
    <div className="skills-list">
      <div className="skills-header">
        <h1>Available Skills</h1>
        <button className="action-btn details-btn" onClick={() => setShowCreateModal(true)}>
          + Create Skill
        </button>
      </div>

      <div className="skills-grid">
        {skills.map((skill) => (
          <div key={skill.id} className="skill-card">
            <h2>{skill.title}</h2>
            <p>{skill.description}</p>
            <span className="skill-type">{skill.skill_type}</span>

            <div className="skill-card-actions">
              {skill.taken ? (
                <span className="skill-taken-text">
                  ✅ This skill has been taken and the match is confirmed.
                </span>
              ) : (
                <>
                  <button className="action-btn details-btn" onClick={() => handleRequestMatch(skill.id)}>
                    {skill.skill_type === "offer"
                      ? "Request Help"
                      : "Offer Help"}
                  </button>

                  <button
                    className="action-btn details-btn"
                    onClick={() => setSelectedSkill(skill)}
                  >
                    View Details
                  </button>
                </>
              )}
            </div>
          </div>
        ))}
      </div>

      {/* VIEW DETAILS MODAL */}
      {selectedSkill && (
        <div className="modal-overlay" onClick={() => setSelectedSkill(null)}>
          <div
            className="modal-content"
            onClick={(e) => e.stopPropagation()}
          >
            <button
              className="modal-close"
              onClick={() => setSelectedSkill(null)}
            >
              ×
            </button>

            <h2>{selectedSkill.title}</h2>
            <p className="modal-description">
              {selectedSkill.description}
            </p>

            <div className="modal-details">
              <p>
                <strong>Type:</strong>{" "}
                {selectedSkill.skill_type === "offer"
                  ? "Offer"
                  : "Request"}
              </p>
              <p>
                <strong>User:</strong>{" "}
                {selectedSkill.user?.username}
              </p>
            </div>
          </div>
        </div>
      )}

      {/* CREATE SKILL MODAL */}
      {showCreateModal && (
        <div
          className="modal-overlay"
          onClick={() => setShowCreateModal(false)}
        >
          <div
            className="create-skill-modal"
            onClick={(e) => e.stopPropagation()}
          >
            <h2>Create Skill</h2>

            <form className="create-skill-form" onSubmit={handleCreateSkill}>
              <input
                type="text"
                placeholder="Title"
                value={title}
                onChange={(e) => setTitle(e.target.value)}
                required
              />

              <textarea
                placeholder="Description"
                value={description}
                onChange={(e) => setDescription(e.target.value)}
                required
              />

              <select
                value={skillType}
                onChange={(e) => setSkillType(e.target.value)}
              >
                <option value="offer">Offer</option>
                <option value="request">Request</option>
              </select>

              <div className="create-skill-actions">
                <button
                  type="button"
                  className="cancel-btn"
                  onClick={() => setShowCreateModal(false)}
                >
                  Cancel
                </button>
                <button type="submit" className="submit-btn">
                  Create
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
