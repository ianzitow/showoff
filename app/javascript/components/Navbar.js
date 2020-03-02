import React from "react";
import {Button, Container, Menu, Modal} from "semantic-ui-react";
import PropTypes from "prop-types";
import LoginForm from "./LoginForm";
import RegisterForm from "./RegisterForm";
import { Link } from "react-router-dom";

class Navbar extends React.Component {

    state = {
        isModalRegisterOpen: false,
        isModalLoginOpen: false
    }

    handleModalRegisterOpen = () => this.setState({isModalRegisterOpen: true})
    handleModalLoginOpen = () => this.setState({isModalLoginOpen: true})

    handleModalClose = () => this.setState({isModalRegisterOpen: false, isModalLoginOpen: false})

    render() {
        return <Menu fixed='top' inverted>
            <Container>
                <Menu.Item header>
                    <Link to={'/'}>Showff Test</Link>
                </Menu.Item>
                {this.props.loggedIn && <Menu.Item><Link to={'/widgets'}>My Widgets</Link></Menu.Item>}
                {this.props.loggedIn && <Menu.Item position={'right'} onClick={this.props.onLogout}>Logout</Menu.Item>}
                {!this.props.loggedIn &&
                <Modal closeIcon onClose={this.handleModalClose} open={this.state.isModalRegisterOpen} trigger={<Menu.Item onClick={this.handleModalRegisterOpen} position='right'>Register</Menu.Item>}>
                    <Modal.Header>Register</Modal.Header>
                    <Modal.Content>
                        <RegisterForm onSubmit={this.props.onSubmit} username={this.props.username}
                                      onChange={this.props.onChange} password={this.props.password} onCloseModal={this.handleModalClose}/>
                    </Modal.Content>
                </Modal>}
                {!this.props.loggedIn &&
                <Modal closeIcon onClose={this.handleModalClose} open={this.state.isModalLoginOpen} trigger={<Menu.Item onClick={this.handleModalLoginOpen}>Login</Menu.Item>}>
                    <Modal.Header>Login</Modal.Header>
                    <Modal.Content>
                        <LoginForm onSubmit={this.props.onSubmit} email={this.props.email}
                                   onChange={this.props.onChange} password={this.props.password}
                                    first_name={this.props.first_name} last_name={this.props.last_name}
                                    image_url={this.props.image_url} onCloseModal={this.handleModalClose}/>
                    </Modal.Content>
                </Modal>}
            </Container>
        </Menu>;
    }
}

Navbar.propTypes = {
    loggedIn: PropTypes.bool,
    onSubmit: PropTypes.func,
    username: PropTypes.string,
    onChange: PropTypes.func,
    password: PropTypes.string,
    onLogout: PropTypes.func
};

export default Navbar