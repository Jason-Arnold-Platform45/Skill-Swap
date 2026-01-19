const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;
const TOKEN_KEY = "authToken";

const handleUnauthorized = () => {
  localStorage.removeItem(TOKEN_KEY);
  window.location.href = "/login";
};

const authHeaders = () => {
  const token = localStorage.getItem(TOKEN_KEY);

  return {
    "Content-Type": "application/json",
    ...(token && { Authorization: `Bearer ${token}` }),
  };
};

const normalizeSkill = (item, included = []) => {
  const userRel = item.relationships?.user?.data;

  const user =
    included.find(
      (i) => i.type === "user" && i.id === userRel?.id
    )?.attributes || null;

  return {
    id: Number(item.id),
    ...item.attributes,
    user,
  };
};

export const fetchSkills = async () => {
  const response = await fetch(`${API_BASE_URL}/skills`, {
    headers: authHeaders(),
  });

  if (response.status === 401) {
    handleUnauthorized();
    return [];
  }

  if (!response.ok) {
    throw new Error("Failed to fetch skills");
  }

  const json = await response.json();

  return json.data.map((item) =>
    normalizeSkill(item, json.included || [])
  );
};
