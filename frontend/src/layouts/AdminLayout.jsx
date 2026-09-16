import { Outlet } from "react-router-dom";

export default function AdminLayout() {
	return (
		<main className="contenido-principal">
			<Outlet />
		</main>
	);
}
