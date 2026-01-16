const API_URL = "http://localhost:3000";

const normalizeSkill = (item, included = []) => {
  const userRel = item.relationships?.user?.data;

  const user =
    included.find(
      (i) => i.type === "user" && i.id === userRel?.id
    )?.attributes || null;

  return {
    id: item.id,
    ...item.attributes,
    user,
  };
};

export const fetchSkills = async () => {
  const response = await fetch(`${API_URL}/skills`);

  if (!response.ok) {
    throw new Error("Failed to fetch skills");
  }

  const json = await response.json();

  return json.data.map((item) =>
    normalizeSkill(item, json.included || [])
  );
};
