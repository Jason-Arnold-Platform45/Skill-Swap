const API_URL = "http://localhost:3000";
const TOKEN_KEY = "authToken";

const normalizeMatch = (item, included = []) => {
  const findIncluded = (type, id) =>
    included.find((i) => i.type === type && i.id === id);

  const skillRel = item.relationships?.skill?.data;
  const requesterRel = item.relationships?.requester?.data;
  const providerRel = item.relationships?.provider?.data;

  const skill = skillRel ? findIncluded("skill", skillRel.id) : null;
  const requester = requesterRel ? findIncluded("user", requesterRel.id) : null;
  const provider = providerRel ? findIncluded("user", providerRel.id) : null;

  return {
    id: Number(item.id),
    ...item.attributes,
    skill: skill
      ? { id: Number(skill.id), ...skill.attributes }
      : null,
    requester: requester
      ? { id: Number(requester.id), ...requester.attributes }
      : null,
    provider: provider
      ? { id: Number(provider.id), ...provider.attributes }
      : null,
  };
};

/**
 * GET /matches
 */
export const fetchMatches = async () => {
  const token = localStorage.getItem(TOKEN_KEY);

  const res = await fetch(`${API_URL}/matches`, {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  });

  if (!res.ok) {
    throw new Error("Failed to fetch matches");
  }

  const json = await res.json();

  return json.data.map((item) =>
    normalizeMatch(item, json.included || [])
  );
};

/**
 * GET /matches/:id
 */
export const fetchMatch = async (matchId) => {
  const token = localStorage.getItem(TOKEN_KEY);

  const res = await fetch(`${API_URL}/matches/${matchId}`, {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  });

  if (!res.ok) {
    throw new Error("Failed to fetch match");
  }

  const json = await res.json();

  return normalizeMatch(json.data, json.included || []);
};

/**
 * PATCH /matches/:id
 */
export const updateMatchStatus = async (matchId, status) => {
  const token = localStorage.getItem(TOKEN_KEY);

  const res = await fetch(`${API_URL}/matches/${matchId}`, {
    method: "PATCH",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
    body: JSON.stringify({
      match: { status },
    }),
  });

  if (!res.ok) {
    throw new Error("Failed to update match status");
  }

  const json = await res.json();

  return normalizeMatch(json.data, json.included || []);
};
