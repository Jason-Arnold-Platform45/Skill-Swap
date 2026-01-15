import { useEffect, useState } from "react";
import { fetchSkills } from "../services/skillsApi";
import { SkillType } from "../types/index";
import LoadingState from "./LoadingState";
import ErrorState from "./ErrorState";

export default function SkillsList() {
  const [skills, setSkills] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [selectedSkill, setSelectedSkill] = useState(null);

  useEffect(() => {
    const loadSkills = async () => {
      try {
        setLoading(true);
        setError(null);
        const data = await fetchSkills();
        setSkills(data);
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    loadSkills();
  }, []);

  const handleRequestMatch = async (skillId) => {
    try {
      const token = localStorage.getItem('authToken');
      const response = await fetch('http://localhost:3000/matches', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`
        },
        body: JSON.stringify({
          match: {
            skill_id: skillId
          }
        })
      });

      if (response.ok) {
        alert('Match request sent successfully!');
        setSelectedSkill(null);
      } else {
        alert('Failed to request match');
      }
    } catch (err) {
      alert('Error: ' + err.message);
    }
  };

  const handleViewDetails = (skill) => {
    setSelectedSkill(skill);
  };

  if (loading) return <LoadingState />;
  if (error) return <ErrorState error={error} />;

  return (
    <div className="skills-list">
      <h1>Available Skills</h1>
      <div className="skills-grid">
        {skills.map((skill) => (
          <div key={skill.id} className="skill-card">
            <h2>{skill.title}</h2>
            <p>{skill.description}</p>
            <span className="skill-type">{skill.skill_type}</span>
            <div className="skill-card-actions">
              {skill.skill_type === 'offer' ? (
                <button 
                  className="action-btn request-btn"
                  onClick={() => handleRequestMatch(skill.id)}
                >
                  Request This Skill
                </button>
              ) : (
                <button 
                  className="action-btn offer-btn"
                  onClick={() => handleRequestMatch(skill.id)}
                >
                  I Can Help
                </button>
              )}
              <button 
                className="action-btn details-btn"
                onClick={() => handleViewDetails(skill)}
              >
                View Details
              </button>
            </div>
          </div>
        ))}
      </div>

      {selectedSkill && (
        <div className="modal-overlay" onClick={() => setSelectedSkill(null)}>
          <div className="modal-content" onClick={(e) => e.stopPropagation()}>
            <button className="modal-close" onClick={() => setSelectedSkill(null)}>×</button>
            <h2>{selectedSkill.title}</h2>
            <p className="modal-description">{selectedSkill.description}</p>
            <div className="modal-details">
              <p><strong>Type:</strong> {selectedSkill.skill_type === 'offer' ? 'Offer' : 'Request'}</p>
              <p><strong>User:</strong> {selectedSkill.user?.username}</p>
            </div>
            <button 
              className="modal-action-btn"
              onClick={() => {
                handleRequestMatch(selectedSkill.id);
                setSelectedSkill(null);
              }}
            >
              {selectedSkill.skill_type === 'offer' ? 'Request This Skill' : 'I Can Help'}
            </button>
          </div>
        </div>
      )}
    </div>
  );
}