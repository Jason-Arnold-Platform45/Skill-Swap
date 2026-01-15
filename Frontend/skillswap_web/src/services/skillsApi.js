const API_URL = "http://localhost:3000";

export const fetchSkills = async () => {
  const response = await fetch(`${API_URL}/skills`);
  
  if (!response.ok) {
    throw new Error("Failed to fetch skills");
  }
  
  return response.json();
};