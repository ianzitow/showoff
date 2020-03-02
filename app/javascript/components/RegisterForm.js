import React from "react";
import {Button, Checkbox, Form} from "semantic-ui-react";
import PropTypes from "prop-types";

class RegisterForm extends React.Component {
    handleSubmit = () => {
        this.props.onSubmit('register')
        this.props.onCloseModal()
    }

    render() {
        return <Form>
            <Form.Input label='First Name'
                        name='first_name'
                        value={this.props.first_name}
                        onChange={this.props.onChange}/>
            <Form.Input label='Last Name'
                        name='last_name'
                        value={this.props.last_name}
                        onChange={this.props.onChange}/>
            <Form.Input label='Email'
                        name='email'
                        value={this.props.email}
                        onChange={this.props.onChange}/>
            <Form.Input label='Enter Password'
                        type='password'
                        name='password'
                        value={this.props.password}
                        onChange={this.props.onChange}/>
            <Form.Input label='Image URL'
                        name='image_url'
                        value={this.props.image_url}
                        onChange={this.props.onChange}/>
            <Form.Field>
                <Checkbox label='I agree to the Terms and Conditions'/>
            </Form.Field>
            <Button onClick={this.handleSubmit} type='button'>Submit</Button>
        </Form>;
    }
}

RegisterForm.propTypes = {
    onSubmit: PropTypes.func,
    email: PropTypes.string,
    onChange: PropTypes.func,
    password: PropTypes.string,
    first_name: PropTypes.string,
    last_name: PropTypes.string,
    image_url: PropTypes.string
};

export default RegisterForm