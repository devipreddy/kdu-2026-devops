ALB Module

Purpose

Deploys an Application Load Balancer in public subnets, configures listeners and target groups for the frontend and backend services, and defines listener rules.

Resources created

- `aws_lb` (application)
- `aws_lb_target_group` (frontend and backend)
- `aws_lb_listener` for HTTP (80) and HTTPS (443)
- Listener rules for application paths

Listeners and rules

- HTTP (80) listener redirects to HTTPS (301)
- HTTPS (443) listener has a default fixed-response 404
- Artist-defined rules route specific API paths (e.g., `/getAmount`, `/addExchangeRate`) to backend target group; default to frontend target group.

Key variables (inputs)

- `public_subnet_ids`
- `alb_sg_id`
- `frontend_target_port`, `backend_target_port`

Outputs

- `alb_dns_name`
- `frontend_tg_arn`
- `backend_tg_arn`

Health checks

Target groups configured with a health check path (e.g., `/health`), interval 30s, timeout 5s, healthy threshold 2, unhealthy threshold 3.
