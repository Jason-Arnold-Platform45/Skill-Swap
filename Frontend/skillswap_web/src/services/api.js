export const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

export const authHeaders = () => {
  const token = localStorage.getItem("authToken");

  return {
    "Content-Type": "application/json",
    ...(token && { Authorization: `Bearer ${token}` }),
  };
};
