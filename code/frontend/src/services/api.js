import axios from "axios";
const API = axios.create({
  baseURL: "http://localhost:1511",
});
export default API;
