const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;
const TOKEN_KEY = "authToken";

const authHeaders = () => {
  const token = localStorage.getItem(TOKEN_KEY);
  return {
    "Content-Type": "application/json",
    ...(token && { Authorization: `Bearer ${token}` }),
  };
};

export const fetchMatches = async () => {
  const res = await fetch(`${API_BASE_URL}/matches`, {
    headers: authHeaders(),
  });

  if (res.status === 401) {
    localStorage.removeItem(TOKEN_KEY);
    window.location.href = "/login";
    return [];
  }

  if (!res.ok) {
    throw new Error("Failed to fetch matches");
  }

  return await res.json(); // ⬅️ RETURN FULL JSONAPI RESPONSE
};

export const updateMatchStatus = async (matchId, status) => {
  const res = await fetch(`${API_BASE_URL}/matches/${matchId}`, {
    method: "PATCH",
    headers: authHeaders(),
    body: JSON.stringify({ match: { status } }),
  });

  if (res.status === 401) {
    localStorage.removeItem(TOKEN_KEY);
    window.location.href = "/login";
    return;
  }

  if (!res.ok) {
    throw new Error("Failed to update match status");
  }

  return await res.json();
};
