const API_URL = "http://localhost:3000";

export async function fetchMatches() {
  const token = localStorage.getItem("authToken");

  const res = await fetch(`${API_URL}/matches`, {
    headers: {
      Authorization: `Bearer ${token}`
    }
  });

  if (!res.ok) {
    throw new Error("Failed to load matches");
  }

  return res.json();
}

export async function updateMatchStatus(matchId, status) {
  const token = localStorage.getItem("authToken");

  const res = await fetch(`${API_URL}/matches/${matchId}`, {
    method: "PATCH",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`
    },
    body: JSON.stringify({
      match: { status }
    })
  });

  if (!res.ok) {
    throw new Error("Failed to update match");
  }

  return res.json();
}
