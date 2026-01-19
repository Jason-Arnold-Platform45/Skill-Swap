import React, { useEffect, useState } from "react";
import { fetchMatches, updateMatchStatus } from "../services/matchesApi";
import LoadingState from "./LoadingState";
import ErrorState from "./ErrorState";

export default function MatchesList({ user }) {
  const [matches, setMatches] = useState([]);
  const [included, setIncluded] = useState([]);
  const [selectedMatch, setSelectedMatch] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // normalize JSON:API user
  const normalizedUser = user?.data
    ? { id: user.data.id, ...user.data.attributes }
    : user;

  useEffect(() => {
    loadMatches();
  }, []);

  const loadMatches = async () => {
    try {
      setLoading(true);
      const response = await fetchMatches();
      setMatches(response?.data || []);
      setIncluded(response?.included || []);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleDecision = async (matchId, status) => {
    await updateMatchStatus(matchId, status);
    loadMatches();
  };

  const findIncluded = (type, id) =>
    included.find(
      (item) => item.type === type && String(item.id) === String(id)
    )?.attributes;

  if (!normalizedUser?.id) return null;
  if (loading) return <LoadingState />;
  if (error) return <ErrorState error={error} />;

  return (
    <div className="skills-list">
      <h1>Your Matches</h1>

      <div className="skills-grid">
        {matches.map((match) => {
          const status = match.attributes.status;

          const skillId = match.relationships.skill.data.id;
          const requesterId = match.relationships.requester.data.id;
          const providerId = match.relationships.provider.data.id;

          const skill = findIncluded("skill", skillId);
          const requester = findIncluded("user", requesterId);
          const provider = findIncluded("user", providerId);

          const isProvider =
            String(providerId) === String(normalizedUser.id);

          return (
            <div key={match.id} className="skill-card">
              <h2>{skill?.title}</h2>

              <p>
                <strong>Requester:</strong> {requester?.username}
              </p>
              <p>
                <strong>Provider:</strong> {provider?.username}
              </p>

              <span className="skill-type">{status}</span>

              {status === "pending" && isProvider && (
                <div className="skill-card-actions">
                  <button
                    className="action-btn details-btn"
                    onClick={() => handleDecision(match.id, "accepted")}
                  >
                    Accept
                  </button>
                  <button
                    className="action-btn details-btn"
                    onClick={() => handleDecision(match.id, "rejected")}
                  >
                    Reject
                  </button>
                </div>
              )}

              {status === "accepted" && (
                <div className="skill-card-actions">
                  <button
                    className="action-btn details-btn"
                    onClick={() =>
                      setSelectedMatch({
                        match,
                        skill,
                        requester,
                        provider,
                      })
                    }
                  >
                    View Details
                  </button>
                </div>
              )}
            </div>
          );
        })}
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

            <h2>{selectedMatch.skill?.title}</h2>

            <p className="modal-description">
              {selectedMatch.skill?.description}
            </p>

            <div className="modal-details">
              <p>
                <strong>Status:</strong> Accepted ✔
              </p>
              <p>
                <strong>Requester:</strong>{" "}
                {selectedMatch.requester?.username}
              </p>
              <p>
                <strong>Provider:</strong>{" "}
                {selectedMatch.provider?.username}
              </p>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
