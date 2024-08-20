import React from 'react';
import { Link } from 'react-router-dom';
import './Navbar.css';

const Navbar = () => {
    return (
        <nav className="navbar">
            <div className="navbar-left">
                <Link to="/"><img src="/hashicorp.png" alt="logo" className="logo" /></Link>
            </div>
            <div className="navbar-center">
                <ul className="nav-links">
                    <li>
                        <Link to="/escape-room">Escape Room</Link>
                    </li>
                    <li>
                        <Link to="/robots">Robots</Link>
                    </li>
                    <li>
                        <Link to="/delete">DELETE</Link>
                    </li>
                </ul>
            </div>
        </nav>
    );
};

export default Navbar;