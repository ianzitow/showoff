import React from "react";
import {Button, Checkbox, Form} from "semantic-ui-react";
import PropTypes from "prop-types";

class LoginForm extends React.Component {
    handleSubmit = () => {
        this.props.onSubmit('login')
        this.props.onCloseModal()
    }
    handleReset = () => {
        this.props.onSubmit('reset')
        this.props.onCloseModal()
    }

    render() {
        return <Form>
            <Form.Input label='Enter Username'
                        name='username'
                        value={this.props.username}
                        onChange={this.props.onChange}/>
            <Form.Input label='Enter Password'
                        type='password'
                        name='password'
                        value={this.props.password}
                        onChange={this.props.onChange}/>
            <Form.Field>
                <Checkbox label='I agree to the Terms and Conditions'/>
            </Form.Field>
            <Button onClick={this.handleSubmit} type='button'>Submit</Button>
            <Button onClick={this.handleReset}>Reset Password</Button>
        </Form>;
    }
}

LoginForm.propTypes = {
    onSubmit: PropTypes.func,
    username: PropTypes.string,
    onChange: PropTypes.func,
    password: PropTypes.string
};

export default LoginForm