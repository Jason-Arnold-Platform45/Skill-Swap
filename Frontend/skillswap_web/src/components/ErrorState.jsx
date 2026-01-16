import React from "react";
export default function ErrorState({ error }) {
  return (
    <div className="error-state">
      <p>Error: {error}</p>
      <button onClick={() => window.location.reload()}>Retry</button>
    </div>
  );
}