import { useEffect, useState } from "react";
import { fetchSkills } from "../services/skillsApi";
import { SkillType } from "../types/index";
import LoadingState from "./LoadingState";
import ErrorState from "./ErrorState";

export default function SkillsList() {
  const [skills, setSkills] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

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
          </div>
        ))}
      </div>
    </div>
  );
}