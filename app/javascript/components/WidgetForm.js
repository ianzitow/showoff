import React from "react";
import {Button, Checkbox, Form} from "semantic-ui-react";
import PropTypes from "prop-types";

class WidgetForm extends React.Component {
    handleSubmit = () => {
        this.props.onSubmit('create-widget')
        this.props.onCloseModal()
    }

    render() {
        return <Form>
            <Form.Input label='Enter Name'
                        name='name'
                        value={this.props.name}
                        onChange={this.props.onChange}/>
            <Form.Input label='Enter Description'
                        name='description'
                        value={this.props.description}
                        onChange={this.props.onChange}/>
            <Form.Field>
                <Checkbox checked={this.props.visible} label='Make my widget visible to everyone.'/>
            </Form.Field>
            <Button onClick={this.handleSubmit} type='button'>Submit</Button>
        </Form>;
    }
}

WidgetForm.propTypes = {
    name: PropTypes.string,
    description: PropTypes.string,
    visible: PropTypes.bool,
};

export default WidgetForm