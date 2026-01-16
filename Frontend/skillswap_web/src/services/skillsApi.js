const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

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
  const token = localStorage.getItem("authToken");

  const response = await fetch(`${API_BASE_URL}/skills`, {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  });

  if (!response.ok) {
    throw new Error("Failed to fetch skills");
  }

  const json = await response.json();

  return json.data.map((item) =>
    normalizeSkill(item, json.included || [])
  );
};
