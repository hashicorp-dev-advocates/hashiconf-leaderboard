import { useForm } from "react-hook-form"
import { useEffect } from 'react';
import createTeam from "./api/leaderboard"

export default function EscapeRoom() {
    const {
        register,
        handleSubmit,
        reset,
        formState,
        formState: { errors }
    } = useForm();

    const onSubmit = async data => {
        let response = await createTeam(data);
        if (response !== null) {
            alert("Created team with ID " + response.id + " for workflow " + response.activation)
        } else {
            alert("Error: could not create team")
        }
    };

    useEffect(() => {
        if (formState.isSubmitSuccessful) {
            reset();
        }
    }, [formState, reset]);

    return (
        <form onSubmit={handleSubmit(onSubmit)}>
            <h1>Escape Room</h1>
            <label>Team name</label>
            <input
                {...register("name", {
                    required: true,
                    maxLength: 65,
                })}
            />
            {errors?.name?.type === "required" && <p>This field is required</p>}
            {errors?.name?.type === "maxLength" && (
                <p>Team name cannot exceed 65 characters</p>
            )}
            <label>Time in seconds</label>a
            <input type="number" {...register("time", { required: true, min: 1, max: 1200, valueAsNumber: true })} />
            {errors.time && (
                <p>Time must be in seconds and less than 20 minutes (1200 seconds)</p>
            )}
            <label>Workflow</label>a
            <select {...register("activation", { required: true })}>
                <option value="ilm">ILM</option>
                <option value="slm">SLM</option>
            </select>
            <input type="submit" />
        </form>
    );
}