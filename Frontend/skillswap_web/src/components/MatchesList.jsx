import { useEffect, useState } from "react";
import { fetchMatches, updateMatchStatus } from "../services/matchesApi";
import LoadingState from "./LoadingState";
import ErrorState from "./ErrorState";

export default function MatchesList({ user }) {
  const [matches, setMatches] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    loadMatches();
  }, []);

  const loadMatches = async () => {
    try {
      setLoading(true);
      const data = await fetchMatches();
      setMatches(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleDecision = async (matchId, status) => {
    try {
      await updateMatchStatus(matchId, status);
      loadMatches();
    } catch (err) {
      alert(err.message);
    }
  };

  if (loading) return <LoadingState />;
  if (error) return <ErrorState error={error} />;

  return (
    <div className="skills-list">
      <h1>Your Matches</h1>

      <div className="skills-grid">
        {matches.map((match) => (
          <div key={match.id} className="skill-card">
            <h2>{match.skill.title}</h2>

            <p>
              <strong>Requester:</strong> {match.requester.username}
            </p>
            <p>
              <strong>Provider:</strong> {match.provider.username}
            </p>

            <span className="skill-type">{match.status}</span>

            {match.status === "pending" &&
              match.provider.id === user.id && (
                <div className="skill-card-actions">
                  <button
                    onClick={() => handleDecision(match.id, "accepted")}
                  >
                    Accept
                  </button>
                  <button
                    onClick={() => handleDecision(match.id, "rejected")}
                  >
                    Reject
                  </button>
                </div>
              )}
          </div>
        ))}
      </div>
    </div>
  );
}
