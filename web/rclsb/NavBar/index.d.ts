export interface NavBarProps {
    header: string;
    onMenuCallback?: () => void;
    onThemeCallback?: () => void;
}
export default function NavBar(props: Readonly<NavBarProps>): import("react/jsx-runtime").JSX.Element;
