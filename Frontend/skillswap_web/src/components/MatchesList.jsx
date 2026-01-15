import { useEffect, useState } from "react";
import { fetchMatches, updateMatchStatus } from "../services/matchesApi";
import LoadingState from "./LoadingState";
import ErrorState from "./ErrorState";

export default function MatchesList({ user }) {
  const [matches, setMatches] = useState([]);
  const [selectedMatch, setSelectedMatch] = useState(null);
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

            {/* PENDING → Provider can decide */}
            {match.status === "pending" &&
              match.provider.id === user.id && (
                <div className="skill-card-actions">
                  <button
                    onClick={() =>
                      handleDecision(match.id, "accepted")
                    }
                  >
                    Accept
                  </button>
                  <button
                    onClick={() =>
                      handleDecision(match.id, "rejected")
                    }
                  >
                    Reject
                  </button>
                </div>
              )}

            {/* ACCEPTED → View Details */}
            {match.status === "accepted" && (
              <div className="skill-card-actions">
                <button onClick={() => setSelectedMatch(match)}>
                  View Details
                </button>
              </div>
            )}
          </div>
        ))}
      </div>

      {/* VIEW DETAILS MODAL */}
      {selectedMatch && (
        <div
          className="modal-overlay"
          onClick={() => setSelectedMatch(null)}
        >
          <div
            className="modal-content"
            onClick={(e) => e.stopPropagation()}
          >
            <button
              className="modal-close"
              onClick={() => setSelectedMatch(null)}
            >
              ×
            </button>

            <h2>{selectedMatch.skill.title}</h2>

            <p className="modal-description">
              {selectedMatch.skill.description}
            </p>

            <div className="modal-details">
              <p>
                <strong>Status:</strong> Accepted ✔
              </p>
              <p>
                <strong>Requester:</strong>{" "}
                {selectedMatch.requester.username}
              </p>
              <p>
                <strong>Provider:</strong>{" "}
                {selectedMatch.provider.username}
              </p>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
