from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import AllowAny
import logging

logger = logging.getLogger(__name__)

class HealthCheckView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, *args, **kwargs):
        response_data = {
            "status": "ok"
        }
        logger.info("Health check endpoint accessed successfully.")
        return Response(response_data, status=status.HTTP_200_OK)